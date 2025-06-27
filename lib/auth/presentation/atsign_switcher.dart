import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:atmail/app.dart';
import 'package:atmail/auth/blocs/available_atsigns_cubit.dart';
import 'package:atmail/router/router.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtsignSwitcher extends StatefulWidget {
  const AtsignSwitcher({super.key});

  @override
  AtsignSwitcherState createState() => AtsignSwitcherState();
}

class AtsignSwitcherState extends State<AtsignSwitcher> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _switcherKey = GlobalKey();

  void _showDropdown() {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    final RenderBox renderBox = _switcherKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(offset, size);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(Offset offset, Size size) {
    final cubit = context.read<AvailableAtsignsCubit>();
    final theme = Theme.of(context);

    return OverlayEntry(
      builder: (overlayContext) => GestureDetector(
        onTap: _hideDropdown, // Close when tapping outside
        child: Stack(
          children: [
            // Invisible barrier to capture outside taps
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // The actual dropdown
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + theme.appSpacing.verySmall,
              width: size.width,
              child: GestureDetector(
                onTap: () {}, // Prevent event bubbling when tapping inside dropdown
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(theme.appRadius.medium),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: BlocProvider.value(
                      value: cubit,
                      child: BlocBuilder<AvailableAtsignsCubit, AvailableAtsignsState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return Padding(
                              padding: EdgeInsets.all(theme.appSpacing.medium),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state.error != null) {
                            return Padding(
                              padding: EdgeInsets.all(theme.appSpacing.medium),
                              child: Text('Error: ${state.error}'),
                            );
                          }

                          final currentAtSign = AtClientManager.getInstance().atClient.getCurrentAtSign();
                          final otherAtSigns = state.atsigns.where((atsign) => atsign != currentAtSign).toList();

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (otherAtSigns.isNotEmpty) ...[
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: otherAtSigns.length,
                                    itemBuilder: (context, index) {
                                      final atsign = otherAtSigns[index];
                                      return ListTile(
                                        title: Text(atsign),
                                        onTap: () {
                                          _hideDropdown();
                                          _switchToAtSign(atsign);
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Divider(height: 1),
                              ],
                              ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Logout'),
                                onTap: () {
                                  _hideDropdown();
                                  _logout();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchToAtSign(String atsign) {
    // TODO: Implement AtSign switching logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switching to $atsign (not implemented yet)')),
    );
  }

  void _logout() async {
    try {
      final resetResult = await AtOnboarding.reset(
        context: context,
        config: AtOnboardingConfig(
          atClientPreference: context.read<AppDependencies>().atClientPreferences,
          rootEnvironment: RootEnvironment.Production,
        ),
      );
      switch (resetResult) {
        case AtOnboardingResetResult.cancelled:
        // Do nothing
        case AtOnboardingResetResult.success:
          if (mounted) {
            OnboardingRoute().go(context);
          }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atSign = AtClientManager.getInstance().atClient.getCurrentAtSign();
    return Card(
      key: _switcherKey,
      elevation: 0,
      color: theme.colorScheme.secondaryContainer,
      child: InkWell(
        onTap: _showDropdown,
        child: Padding(
          padding: EdgeInsets.all(theme.appSpacing.small),
          child: Row(
            children: [
              Text(
                atSign ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              SizedBox(width: theme.appSpacing.verySmall),
              Spacer(),
              Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

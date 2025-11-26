import 'package:atmail/messaging/blocs/new_message_cubit.dart';
import 'package:atmail/messaging/presentation/display_markdown.dart';
import 'package:atmail/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

  @override
  MessageInputFieldState createState() => MessageInputFieldState();
}

class MessageInputFieldState extends State<MessageInputField> {
  late final _messageController = MarkdownTextEditingController();
  late final _focusNode = FocusNode(debugLabel: 'MessageInputField');

  final _formKey = GlobalKey<FormState>();

  bool _showFormattingOptions = false;
  bool _showPreview = false;

  void _submitMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      final messageText = _messageController.text.trim();
      context.read<NewMessageCubit>().addMarkdownMessage(messageText);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showFormattingOptions && !_showPreview) ...[
            TextFieldTapRegion(
              child: FormattingBar(
                controller: _messageController,
                focusNode: _focusNode,
              ),
            ),
            SizedBox(height: theme.appSpacing.small),
          ],
          if (_showPreview) ...[
            Text(
              'Message Preview',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.semanticColors.warning),
            ),
            SizedBox(height: theme.appSpacing.small),
          ],
          _showPreview
              ? Padding(
                  padding: EdgeInsets.all(theme.appSpacing.medium),
                  child: DisplayMarkdown(data: _messageController.text),
                )
              : Flexible(
                  // TODO: Update the highlighted colour so that it's visible.
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _messageController,
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    maxLength: 1000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message cannot be empty';
                      }
                      if (value.trim().length > 1000) {
                        return 'Message is too long (max 1000 characters)';
                      }
                      // TODO: Basic validation of the markdown
                      return null;
                    },
                  ),
                ),
          SizedBox(height: theme.appSpacing.small),
          Row(
            children: [
              TextFieldTapRegion(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  tooltip: 'Add attachment',
                ),
              ),
              TextFieldTapRegion(
                child: IconButton(
                  onPressed: () {
                    if (!_focusNode.hasFocus) {
                      _focusNode.requestFocus();
                    }
                    _messageController.insertMention();
                  },
                  icon: const Icon(Icons.alternate_email),
                  tooltip: 'Mention',
                ),
              ),
              TextFieldTapRegion(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showFormattingOptions = !_showFormattingOptions;
                    });
                  },
                  icon: Icon(
                    _showFormattingOptions ? Icons.text_format : Icons.text_format_outlined,
                    color: _showFormattingOptions ? theme.colorScheme.primary : null,
                  ),
                  tooltip: _showFormattingOptions ? 'Hide formatting options' : 'Show formatting options',
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showPreview = !_showPreview;
                  });
                },
                icon: Icon(
                  _showPreview ? Icons.visibility_off : Icons.visibility,
                ),
                tooltip: _showPreview ? 'Hide preview' : 'Show preview',
              ),
              Spacer(),
              IconButton(
                onPressed: null,
                icon: const Icon(Icons.timer),
                tooltip: 'Send 1 time message',
              ),
              IconButton(
                onPressed: _submitMessage,
                icon: const Icon(Icons.send),
                tooltip: 'Send message',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FormattingBar extends StatefulWidget {
  const FormattingBar({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final MarkdownTextEditingController controller;
  final FocusNode focusNode;

  @override
  FormattingBarState createState() => FormattingBarState();
}

class FormattingBarState extends State<FormattingBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(theme.appRadius.small),
      ),
      child: Wrap(
        children: [
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertEmptyBold();
            },
            icon: const Icon(Icons.format_bold),
            tooltip: 'Bold',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertEmptyItalic();
            },
            icon: const Icon(Icons.format_italic),
            tooltip: 'Italic',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertEmptyStrikethrough();
            },
            icon: const Icon(Icons.strikethrough_s),
            tooltip: 'Strikethrough',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertEmptyInlineCode();
            },
            icon: const Icon(Icons.code),
            tooltip: 'Inline code',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertEmptyLink();
            },
            icon: const Icon(Icons.link),
            tooltip: 'Link',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertUnorderedListItem();
            },
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'Unordered list',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertOrderedListItem();
            },
            icon: const Icon(Icons.format_list_numbered),
            tooltip: 'Ordered list',
          ),
          IconButton(
            onPressed: () {
              if (!widget.focusNode.hasFocus) {
                widget.focusNode.requestFocus();
              }
              widget.controller.insertBlockquote();
            },
            icon: const Icon(Icons.format_quote),
            tooltip: 'Blockquote',
          ),
        ],
      ),
    );
  }
}

// TODO: Add some logic so that when pressing enter when in an ordered or unordered list,
// the next item is automatically created with the correct number or bullet point.
// Also when pressing enter again, the list is exited.

// TODO: When text is already highlighted/selected, add appropriate formatting around it.

class MarkdownTextEditingController extends TextEditingController {
  void insertEmptyBold() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert **** at cursor position
    final newText = text.replaceRange(start, end, '****');

    // Position cursor in the middle (2 characters after insertion point)
    final newCursorPosition = start + 2;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertMention() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert @ at cursor position
    final newText = text.replaceRange(start, end, '@');

    // Position cursor after @
    final newCursorPosition = start + 1;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertEmptyItalic() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert ** at cursor position
    final newText = text.replaceRange(start, end, '**');

    // Position cursor in the middle (1 character after insertion point)
    final newCursorPosition = start + 1;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertEmptyStrikethrough() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert ~~~~ at cursor position
    final newText = text.replaceRange(start, end, '~~~~');

    // Position cursor in the middle (2 characters after insertion point)
    final newCursorPosition = start + 2;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertEmptyInlineCode() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert `` at cursor position
    final newText = text.replaceRange(start, end, '``');

    // Position cursor in the middle (1 character after insertion point)
    final newCursorPosition = start + 1;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertEmptyLink() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Insert [text](url) at cursor position
    final newText = text.replaceRange(start, end, '[text](url)');

    // Position cursor to select "text" (1 character after [, length 4)
    final newCursorStart = start + 1;
    final newCursorEnd = start + 5;

    value = value.copyWith(
      text: newText,
      selection: TextSelection(baseOffset: newCursorStart, extentOffset: newCursorEnd),
    );
  }

  void insertUnorderedListItem() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Check if we need to add a newline before the list item
    final needsNewline = start > 0 && text[start - 1] != '\n';
    final prefix = needsNewline ? '\n- ' : '- ';

    // Insert list item at cursor position
    final newText = text.replaceRange(start, end, prefix);

    // Position cursor after the dash and space
    final newCursorPosition = start + prefix.length;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertBlockquote() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Check if we need to add a newline before the blockquote
    final needsNewline = start > 0 && text[start - 1] != '\n';
    final prefix = needsNewline ? '\n> ' : '> ';

    // Insert blockquote at cursor position
    final newText = text.replaceRange(start, end, prefix);

    // Position cursor after the > and space
    final newCursorPosition = start + prefix.length;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void insertOrderedListItem() {
    final text = value.text;
    final selection = value.selection;

    // Handle invalid selection by using end of text
    final start = selection.start == -1 ? text.length : selection.start;
    final end = selection.end == -1 ? text.length : selection.end;

    // Check if we need to add a newline before the list item
    final needsNewline = start > 0 && text[start - 1] != '\n';
    final prefix = needsNewline ? '\n1. ' : '1. ';

    // Insert ordered list item at cursor position
    final newText = text.replaceRange(start, end, prefix);

    // Position cursor after the number, dot and space
    final newCursorPosition = start + prefix.length;

    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}

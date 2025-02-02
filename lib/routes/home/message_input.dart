import 'package:flutter/material.dart';
import 'package:nuthoughts/constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

class MessageInput extends StatefulWidget {
  const MessageInput(
      this.isEditing, this.textController, this.onChanged, this.onSendPressed,
      {super.key});

  final bool isEditing;
  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  final Function(String) onSendPressed;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  void initState() {
    super.initState();
    initializeTextController();
  }

  void initializeTextController() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.textController.text = prefs.getString(constants.textKey) ?? '';
    });
  }

  @override
  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    widget.onSendPressed(widget.textController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ThemeData.dark().cardColor,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.isEditing)
                                const Text(
                                  'Editing Thought',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              TextField(
                                autofocus: true,
                                minLines: 1,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: 'What are you thinking?',
                                ),
                                controller: widget.textController,
                                onChanged: (text) {
                                  setState(() {});
                                  widget.onChanged(widget.textController.text);
                                },
                              ),
                            ]))),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                  disabledColor: Colors.grey,
                  onPressed: widget.textController.text.trim().isEmpty
                      ? null
                      : _sendMessage,
                ),
              ],
            )));
  }
}

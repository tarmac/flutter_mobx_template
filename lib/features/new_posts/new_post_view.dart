import 'dart:async';

import 'package:flutter/material.dart';

import '../../design_system/widgets/buttons/button_with_icon_full_size.dart';
import '../../helpers/show_adaptive_dialog.dart';
import 'new_post_view_model.dart';
import 'widgets/header_input_text.dart';
import 'widgets/input_text.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({
    super.key,
  });

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController(text: '');

  final _viewModel = NewPostViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const HeaderInputText(text: 'New Post'),
              InputText(
                textEditingController: textController,
                validator: validateTextPost,
              ),
              ButtonWithIconFullSize(
                onPressed: onSaveClicked,
                text: 'save',
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateTextPost(String? value) {
    if (value == null || value.isEmpty) return 'Please insert a message to your new post';
    return null;
  }

  Future<void> onSaveClicked() async {
    try {
      if (!formKey.currentState!.validate()) throw const FormatException('The Form is invalid');
      final navigator = Navigator.of(context);

      final post = await _viewModel.addNewPost(textController.text, DateTime.now().toString());
      textController.clear(); // empty TextEditingController
      navigator.pop(post);
    } catch (e, _) {
      await showAdaptiveDialog(context: context, title: 'Error', content: e.toString());
    }
  }
}

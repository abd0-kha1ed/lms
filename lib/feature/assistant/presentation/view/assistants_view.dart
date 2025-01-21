import 'package:flutter/material.dart';
import 'package:video_player_app/feature/assistant/presentation/view/widget/assistant_view_body.dart';

class AssistantsView extends StatelessWidget {
const AssistantsView({ super.key });
@override
Widget build(BuildContext context) {
return Scaffold(

body: AssistantViewBody(),
);
}
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color black= Color(0xff000000);
const Color white = Colors.white;
const Color primaryColor = Color(0xff5bf3de);
const Color secondaryColor = Color(0xfff9da5d);
const Color negButtonColor= Color(0xffc293f5);
const Color errorFieldColor = Color(0xffffa53b);


/////////////////////////////////
///   TEXT STYLES
////////////////////////////////



 headerText({double size}) => TextStyle(
    fontFamily: "Courgette",
    fontSize: size,
    color: primaryColor)

;
 headerText15({double size}) => TextStyle(
    fontFamily: "Courgette",
    fontSize: size,
    color: primaryColor)

;
 headerTextItalic({double size}) => TextStyle(
    fontFamily: 'ZillaSlab',
    fontSize: size,
    fontStyle: FontStyle.italic,
    color: primaryColor);

 storyText({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  fontSize:size,
  color: primaryColor,
);

 replyText({double size}) => TextStyle(

  fontFamily: 'ZillaSlab',
  fontSize: size,
  color: secondaryColor,

);


 storypageHeaderText({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  fontSize: size,
  color: secondaryColor,
);


 composeStoryText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',
  fontSize: size,
  color: secondaryColor,
);


 reviewStoryTextTitle({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  color: primaryColor,
  fontSize: size,


);

 reviewStoryTextStory({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  color: primaryColor,
  fontSize: size,
);

 reviewStoryTextTitleHeader({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  color: secondaryColor,
  fontSize: size,
);

 reviewStoryTextStoryHeader({double size}) => TextStyle(
    fontFamily: 'ZillaSlab',
    color: secondaryColor,
    fontSize: size);

 readStoryButton({double size}) => TextStyle(
  fontFamily: 'Ruda',
  color: secondaryColor,
  fontSize: size,

);

 viewAllButton({double size})  => TextStyle(
    fontFamily: 'Ruda',
    color: secondaryColor,
    fontSize: size
);
 reviewButton({double size,var color})  => TextStyle(
    fontFamily: 'Ruda',
    color: color,
    fontSize: size
);
 deleteButton({double size}) => TextStyle(
    fontFamily: 'Ruda',
    color: white,
    fontSize: size
);

 updateButton({double size})  => TextStyle(
    fontFamily: 'Ruda',
    color: white,
    fontSize: size
);
 errorText({double size})  => TextStyle(
    fontFamily: 'ZillaSlab',
    color: errorFieldColor,
    fontSize: size
);

 logoutButton({double size})  => TextStyle(
    fontFamily: 'Ruda',
    backgroundColor: negButtonColor,
    color: white,
    fontSize: size
);

 homeSubHeaderText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',
  color: primaryColor,
  fontSize: size,


);

 homeStoryTitleText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',
  color: primaryColor,
  fontSize: size,



);

 homeSliderStoryTitleText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',
  color: secondaryColor,
  fontSize: size,

  fontWeight: FontWeight.w500,

);

 homeSliderReadStoryButton({double size}) => TextStyle(
    color: primaryColor,
    fontSize: size,
    fontWeight: FontWeight.w800,
    fontFamily: 'ZillaSlab');

 sendAStoryReviewStoryButton({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',
  backgroundColor: primaryColor,
  color: black,
  fontSize: size,
);

 welcomeText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',

  color: secondaryColor,
  fontSize: size,
);
 sendAStoryHintText({double size})  => TextStyle(
  fontFamily: 'ZillaSlab',

  color: secondaryColor,
  fontSize: size,
);

 sectionTabHeaderText({double size})  => TextStyle(
  fontFamily: 'Courgette',
  fontSize: size,
  color: secondaryColor,

);

 bottomNavBarText({double size}) =>
TextStyle(
  fontFamily: 'Courgette',
  fontSize: size,
);

 sendAStoryDeleteButton({double size}) => TextStyle(
    fontFamily: 'ZillaSlab',
    backgroundColor: negButtonColor,
    color: white,
    fontSize: size);


 reviewStorySendAStoryButton({double size}) => TextStyle(
    fontFamily: 'ZillaSlab',
    backgroundColor: primaryColor,
    color: black,
    fontSize: size);

 reviewStoryEditStoryButton({double size}) => TextStyle(
    fontFamily: 'Ruda',
    backgroundColor: secondaryColor,
    color: black,
    fontSize: size);

 appBarBackButton({double size}) => TextStyle(
  fontFamily: 'ZillaSlab-Light',
  color: secondaryColor,

);

 formFieldLabelText({double size}) => TextStyle(
  fontFamily: 'ZillaSlab-LightItalic',
  color:secondaryColor,
);

 AckText({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  color:secondaryColor,
  fontSize: size,


); AckTextRole({double size}) => TextStyle(
  fontFamily: 'ZillaSlab',
  color:primaryColor,
  fontSize: size,


);

 formFieldHintText() =>
TextStyle(  fontFamily: 'ZillaSlab-SemiBold',
  color:secondaryColor,
);

const formFieldPasswordText = TextStyle(
    letterSpacing: 3
);


///////////////////////////////////
/// BOX DECORATION STYLES
//////////////////////////////////



const formFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      color: secondaryColor,
    ));

const errorFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    borderSide: BorderSide(
      color: errorFieldColor,
    ));



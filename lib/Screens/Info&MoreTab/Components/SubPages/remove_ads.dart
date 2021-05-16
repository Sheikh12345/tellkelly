import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card/credit_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:tellkelly/Services/StripePayment/stripe_service.dart';
import 'package:tellkelly/Style/style_sheet.dart';
import '../../../../stripe_model.dart';

class RemoveAds extends StatefulWidget {
  final String amount;
  const RemoveAds({Key key, this.amount}) : super(key: key);

  @override
  _RemoveAdsState createState() => _RemoveAdsState();
}

class _RemoveAdsState extends State<RemoveAds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  TextEditingController _controllerCardNum = TextEditingController();
  TextEditingController _controllerExpiry = TextEditingController();
  TextEditingController _controllerCVV = TextEditingController();
  TextEditingController _controllerCardHolder = TextEditingController();


  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '${widget.amount}00', currency: 'USD');
    await dialog.hide();
    showInSnackBar(context: context, response: response);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back_ios_rounded,color:primaryColor,),
          onPressed: (){
            Navigator.pop(context);
          },),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Payment",
          style: GoogleFonts.courgette(
              color: primaryColor, fontSize: size.width * 0.063),
        ),
      ),
      body: Container(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                height: size.height*0.325,
                textStyle: TextStyle(color: Colors.yellowAccent),
                width: MediaQuery.of(context).size.width,
                animationDuration: Duration(milliseconds: 1000),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height*0.01),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(size.width*0.02),
                      child:   TextField(
                        controller: _controllerCardNum,
                        style: formFieldLabelText(),
                        keyboardType: TextInputType.number,
                        cursorColor: secondaryColor,
                        decoration: InputDecoration(
                          errorBorder: errorFieldBorder,
                          errorStyle: errorText(),
                          focusedErrorBorder: errorFieldBorder,
                          hintStyle: formFieldHintText(),
                          labelText: "Card Number",
                          focusedBorder: formFieldBorder,
                          labelStyle: formFieldLabelText(),
                          enabledBorder: formFieldBorder,
                        ),
                        onChanged: (value){
                          setState(() {
                            cardNumber = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(size.width*0.02),
                      child:   TextField(
                        controller: _controllerExpiry,
                        style: formFieldLabelText(),
                        keyboardType: TextInputType.datetime,
                        cursorColor: secondaryColor,
                        decoration: InputDecoration(
                          errorBorder: errorFieldBorder,
                          errorStyle: errorText(),
                          focusedErrorBorder: errorFieldBorder,
                          hintStyle: formFieldHintText(),
                          labelText: "Expiry Date (MM/YY)",
                          focusedBorder: formFieldBorder,
                          labelStyle: formFieldLabelText(),
                          enabledBorder: formFieldBorder,
                        ),
                        onChanged: (value){
                          setState(() {
                            if( _controllerExpiry.text.length==2){
                            }

                            expiryDate = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(size.width*0.02),
                      child:   TextField(
                        controller: _controllerCVV,
                        keyboardType: TextInputType.number,
                        style: formFieldLabelText(),
                        cursorColor: secondaryColor,
                        decoration: InputDecoration(
                          errorBorder: errorFieldBorder,
                          errorStyle: errorText(),
                          focusedErrorBorder: errorFieldBorder,
                          hintStyle: formFieldHintText(),
                          labelText: "CVV",
                          focusedBorder: formFieldBorder,
                          labelStyle: formFieldLabelText(),
                          enabledBorder: formFieldBorder,
                        ),
                        onChanged: (value){
                          setState(() {
                            cvvCode = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(size.width*0.02),
                      child:   TextField(
                        keyboardType: TextInputType.text,
                        controller: _controllerCardHolder,
                        style: formFieldLabelText(),
                        cursorColor: secondaryColor,
                        decoration: InputDecoration(
                          errorBorder: errorFieldBorder,
                          errorStyle: errorText(),
                          focusedErrorBorder: errorFieldBorder,
                          hintStyle: formFieldHintText(),
                          labelText: "Card Holder",
                          focusedBorder: formFieldBorder,
                          labelStyle: formFieldLabelText(),
                          enabledBorder: formFieldBorder,
                        ),
                        onChanged: (value){
                          setState(() {
                            cardHolderName = value;
                          });
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: size.height*0.03),
                      width: size.width*0.9,
                      height: size.height*0.06,
                      child: MaterialButton(
                        onPressed: (){
                          if(expiryDate.substring(2,3)=="/"){
                            payViaExistingCard(
                                expiry: expiryDate, cardNum: cardNumber, context: context);
                          }else{
                            final snackBar = SnackBar(content: Text('Expiry date is incorrect',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: errorFieldColor,);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        color: primaryColor,
                        child: Text("Subscribe",style:GoogleFonts.ruda(
                          color: Colors.black,
                          fontSize: size.width * 0.034,
                          fontWeight: FontWeight.w600,
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void showInSnackBar({
    String value,
    BuildContext context,
    StripeTransactionResponse response,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(response.message),
      duration: Duration(milliseconds: response.success ? 1300 : 3000),
    ));
  }


  payViaExistingCard(
      {BuildContext context, String expiry, String cardNum}) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = expiry.split('/');
    CreditCard stripeCard = CreditCard(
      number: cardNum,
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '${widget.amount}00', currency: 'USD', card: stripeCard);
    await dialog.hide();
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(
      content: new Text(response.message),
      duration: Duration(milliseconds: 1300),
    ))
        .closed
        .then((_) {
      if (response.success == true) {
        FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser.uid).
        update({
          "subscription":1
        });
        final snackBar = SnackBar(content: Text('You have successfully purchased subscription',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: secondaryColor,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


        final snackBar2 = SnackBar(content: Text('Restart Tell Kelly App',style: GoogleFonts.zillaSlab(color: Colors.black,fontWeight: FontWeight.w500,letterSpacing: 0.8),),duration: Duration(seconds: 1,),backgroundColor: secondaryColor,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }
      Navigator.pop(context);
    });
  }
}

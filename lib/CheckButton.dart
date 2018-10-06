
import 'package:flutter/material.dart';
import 'utils.dart';

class CheckButton extends StatefulWidget {

  CheckButton(
      {Key key,
      this.enable,
      this.checkSuccess,
      this.onTap})
      : super(key: key);

  final bool enable;
  final Function onTap;
  final CHECK_STATUS checkSuccess;

  @override
    _CheckButtonState createState() => new _CheckButtonState();
   
}
class _CheckButtonState extends State<CheckButton> with TickerProviderStateMixin {
  
  AnimationController buttonAnimationController, checkMarkAnimationController;
  Animation buttonSqueezeAnimation, checkmarkAnimation;

  @override
    void initState() {
      super.initState();
      buttonAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
      );
      checkMarkAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
      );
      buttonSqueezeAnimation = Tween(
        begin: 320.0,
        end: 60.0,
      ).animate( CurvedAnimation(
        parent: buttonAnimationController,
        curve:  Interval(0.0, 0.250)
      ));
      checkmarkAnimation = Tween(
        begin: 0.1,
        end: 1.0,
      ).animate( CurvedAnimation(
        parent: checkMarkAnimationController,
        curve:  Interval(0.0, 0.250, curve: Curves.easeOut)
      ));
      buttonSqueezeAnimation.addListener(() {
        setState(() {});
      });
      checkmarkAnimation.addListener(() {
        setState(() {});
      });
    }

  checkSpelling() async {
    print('start animation');
    widget.onTap();
    await buttonAnimationController.forward();
    await checkMarkAnimationController.forward();

  }

  @override
	void dispose(){
	  buttonAnimationController.dispose();
	  checkMarkAnimationController.dispose();
	  super.dispose();
	}

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enable ? checkSpelling : null,
      
      child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    height: 60.0,
                    margin: EdgeInsets.only(bottom: 80.0),
                    width: widget.checkSuccess == CHECK_STATUS.INITIAL ? 320.0 : buttonSqueezeAnimation.value,
                    alignment: FractionalOffset.center,
                    decoration:  BoxDecoration(
                      color:  widget.enable ? Color.fromRGBO(247, 64, 106, 1.0) : widget.checkSuccess == CHECK_STATUS.SUCCESS ? Colors.green :Colors.grey,
                      borderRadius:  BorderRadius.all( Radius.circular(30.0)),
                    ),
                    child: widget.checkSuccess == CHECK_STATUS.INITIAL ?  Text(
                      "Check",
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                      ),
                    ) :  IconTheme(
                        data:  IconThemeData(
                            opacity: checkmarkAnimation.value,
                            size: 40.0,
                            color: Colors.white), 
                        child:  widget.checkSuccess == CHECK_STATUS.SUCCESS ? Icon(Icons.check) : Icon(Icons.close),
                    )
                  ),
                
              )
    );
  }

}

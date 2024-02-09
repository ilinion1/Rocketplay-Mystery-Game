import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystery/source/common/consts/app_colors.dart';
import 'package:mystery/source/common/consts/app_images.dart';
import 'package:mystery/source/common/consts/app_text_styles.dart';
import 'package:mystery/source/common/utils/gap.dart';
import 'package:mystery/source/common/widgets/custom_button.dart';
import 'package:mystery/source/features/controllers/block_button_controller.dart';
import 'package:mystery/source/features/controllers/money_controller.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.onButtonPressed,
    this.text,
  });

  final Function(int) onButtonPressed;
  final String? text;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late final GlobalKey<FormState> _formKey;
  String? errorText;

  final moneys = <int>[10, 25, 50, 100, 200, 500];

  void isValid() {
    if (_controller.text.isEmpty) {
      errorText = null;
      setState(() {});
      return;
    }
    final money = int.parse(_controller.text);
    final userMoney = context.read<MysteryMoneyCubit>().state;
    if (money < 10) {
      errorText = 'You can\'t put money less than 10';
    } else if (money > userMoney) {
      errorText = 'Your balance less than your bet!';
    } else {
      errorText = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colors = <Color>[
    const Color(0xFF15084D).withAlpha(60),
    const Color(0xFF1B70A0).withAlpha(60),
    const Color(0xFFA416A6).withAlpha(60),
    const Color(0xFF7F9B10).withAlpha(60),
    const Color(0xFFFFE792).withAlpha(60),
    const Color(0xFF00EAC0).withAlpha(60),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 65.h,
          child: Form(
            key: _formKey,
            child: TextField(
              controller: _controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.blue,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) => isValid(),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: SvgPicture.asset(AppIcons.money),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 10.w,
                ),
                filled: true,
                fillColor: const Color(0xFF100C22),
                suffixIcon: (_controller.text.isEmpty)
                    ? null
                    : IconButton(
                        onPressed: () => setState(() {
                          _controller.clear();
                          errorText = null;
                        }),
                        icon: SvgPicture.asset(AppIcons.remove),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.pink),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.pink),
                ),
                errorText: errorText,
                errorStyle: AppTextStyles.caption12.copyWith(
                  color: AppColors.pink,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
              child: SizedBox(
                width: 50.w,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: colors[index],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    final money = int.tryParse(_controller.text);
                    _controller.text =
                        ((money ?? 0) + moneys[index]).toString();
                    isValid();
                  },
                  icon: Text('+${moneys[index]}', style: AppTextStyles.caption12),
                ),
              ),
            ),
          ),
        ),
        MysteryGap.height(8.h),
        ValueListenableBuilder(
            valueListenable: MysteryAppProvider.blockButton,
            builder: (context, bool value, _) {
              return SuperCustomButton(
                text: widget.text ?? 'Грати',
                buttonStyleEnum:
                    _controller.text.isEmpty || errorText != null || value
                        ? SuperButtonStyleEnum.cancel
                        : SuperButtonStyleEnum.common,
                onPressed: () {
                  if (_controller.text.isEmpty || errorText != null || value) {
                    return;
                  }
                  if (context.read<MysteryMoneyCubit>().state <
                      int.parse(_controller.text)) {
                    setState(() {
                      errorText = 'Your balance less than your bet!';
                    });
                    return;
                  }
                  widget.onButtonPressed(int.parse(_controller.text));
                },
              );
            }),
      ],
    );
  }
}

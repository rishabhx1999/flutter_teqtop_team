import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teqtop_team/config/app_colors.dart';
import 'package:teqtop_team/consts/app_consts.dart';
import 'package:teqtop_team/controllers/login/login_controller.dart';
import 'package:teqtop_team/utils/validations.dart';
import 'package:teqtop_team/views/widgets/common/common_button.dart';
import 'package:teqtop_team/views/widgets/common/common_input_field.dart';
import 'package:teqtop_team/views/widgets/common/common_password_input_field.dart';

class LoginPage extends StatelessWidget {
  final loginController = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.white),
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
          )),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Form(
            key: loginController.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 168,
                        ),
                        Text('welcome_back'.tr,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: AppColors.kPrimaryColor,
                                fontSize: AppConsts.commonFontSizeFactor * 36,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        Text('sign_in_to_continue'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppColors.kPrimaryColor,
                                    fontSize:
                                        AppConsts.commonFontSizeFactor * 24)),
                        const SizedBox(
                          height: 64,
                        ),
                        CommonInputField(
                          controller: loginController.emailController,
                          hint: 'enter_email',
                          label: 'email',
                          onChanged: (value) {},
                          validator: Validations.checkEmailValidations,
                          inputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CommonPasswordInputField(
                          controller: loginController.passwordController,
                          hint: '********',
                          label: 'password',
                          isShowSuffix: true,
                          validator: Validations.checkPasswordValidations,
                          bottomScrollPadding:
                              MediaQuery.of(context).viewInsets.bottom,
                        ),
                        const SizedBox(
                          height: 168,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Obx(() => loginController.isLoading.value
                          ? Container(
                              height: 51,
                              width: 51,
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                color: AppColors.kPrimaryColor,
                              ),
                            )
                          : CommonButton(
                              text: 'sign_in',
                              onClick: () {
                                loginController.signIn();
                              })),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

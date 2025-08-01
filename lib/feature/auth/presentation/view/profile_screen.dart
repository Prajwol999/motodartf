


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/core/common/app_colors.dart';
import 'package:motofix_app/core/common/shaker_detect.dart';
import 'package:motofix_app/feature/auth/presentation/view/signin_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
// Correct import for the app's color theme
import '../../domain/entity/auth_entity.dart';

const String _defaultAvatarUrl = 'https://cdn.britannica.com/35/238335-050-2CB2EB8A/Lionel-Messi-Argentina-Netherlands-World-Cup-Qatar-2022.jpg';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();

  late ShakeDetector _shakeDetector;

  bool _hasUnsavedChanges = false;
  UserEntity? _originalUser;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        if (mounted) {
          _showLogoutConfirmationDialog(context);
        }
      },
    );
    _shakeDetector.startListening();
    _setupChangeListeners();
  }

  void _setupChangeListeners() {
    _fullNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _addressController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_originalUser != null) {
      final hasChanges = _fullNameController.text != _originalUser!.fullName ||
          _emailController.text != _originalUser!.email ||
          _phoneController.text != (_originalUser!.phone ?? '') ||
          _addressController.text != (_originalUser!.address ?? '');
      if (hasChanges != _hasUnsavedChanges) {
        setState(() {
          _hasUnsavedChanges = hasChanges;
        });
      }
    }
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _populateControllers(UserEntity user) {
    _originalUser = user;
    _fullNameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _hasUnsavedChanges = false;
  }

  // Validation methods remain the same logic
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Full name must be at least 2 characters';
    if (value.trim().length > 50) return 'Full name must be less than 50 characters';
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) return 'Please enter a valid name';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) return 'Please enter a valid email address';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanPhone.length < 10) return 'Phone number must be at least 10 digits';
    if (!RegExp(r'^[+]?[0-9]+$').hasMatch(cleanPhone)) return 'Please enter a valid phone number';
    return null;
  }

  String? _validateAddress(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 5) return 'Address must be at least 5 characters if provided';
    return null;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    return await _showThemedDialog<bool>(
          context: context,
          title: 'Unsaved Changes',
          content: 'You have unsaved changes. Are you sure you want to leave?',
          actions: [
            _ThemedDialogAction(text: 'Stay', isDefault: true, onPressed: () => Navigator.of(context).pop(false)),
            _ThemedDialogAction(text: 'Leave', isDestructive: true, onPressed: () => Navigator.of(context).pop(true)),
          ],
        ) ??
        false;
  }

  void _saveProfile(BuildContext context, UserEntity user) {
    if (!_formKey.currentState!.validate()) return;
    if (_emailController.text.trim() != user.email) {
      _showEmailChangeConfirmation(context, user);
    } else {
      _performUpdate(context, user);
    }
  }

  void _showEmailChangeConfirmation(BuildContext context, UserEntity user) {
    _showThemedDialog(
      context: context,
      title: 'Confirm Email Change',
      content: 'Changing your email may require re-verification. Do you want to continue?',
      actions: [
        _ThemedDialogAction(text: 'Cancel', onPressed: () => Navigator.of(context).pop()),
        _ThemedDialogAction(
            text: 'Continue',
            isDefault: true,
            onPressed: () {
              Navigator.of(context).pop();
              _performUpdate(context, user);
            }),
      ],
    );
  }

  void _performUpdate(BuildContext context, UserEntity user) {
    final updatedUser = user.copyWith(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    );
    context.read<ProfileViewModel>().add(UpdateProfileEvent(userEntity: updatedUser));
  }

  void _resetForm(UserEntity user) {
    _populateControllers(user);
    _formKey.currentState?.reset();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    _showThemedDialog(
      context: context,
      icon: Icons.logout,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      actions: [
        _ThemedDialogAction(text: 'Cancel', onPressed: () => Navigator.of(context).pop()),
        _ThemedDialogAction(
          text: 'Logout',
          isDefault: true,
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ProfileViewModel>().add(LogoutEvent());
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    _showThemedDialog(
      context: context,
      icon: Icons.delete_outline,
      iconColor: AppColors.statusError,
      title: 'Delete Profile',
      content: 'Are you sure you want to delete your profile? This action cannot be undone.',
      actions: [
        _ThemedDialogAction(text: 'Cancel', onPressed: () => Navigator.of(context).pop()),
        _ThemedDialogAction(
          text: 'Delete',
          isDestructive: true,
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ProfileViewModel>().add(DeleteProfileEvent());
          },
        ),
      ],
    );
  }

  Widget _buildRobustAvatar(String? imageUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.neutralDarkGrey,
      child: ClipOval(
        child: Image.network(
          imageUrl ?? _defaultAvatarUrl,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(color: AppColors.textPrimary, strokeWidth: 2));
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person_outline, size: 50, color: AppColors.textSecondary);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.neutralBlack,
        appBar: AppBar(
          title: const Text('Profile'),
          // centerTitle: true,
          backgroundColor: AppColors.neutralDark,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: BlocConsumer<ProfileViewModel, ProfileState>(
          listener: (context, state) {
            if (state.onError != null) {
              _showThemedSnackBar(context, message: state.onError!, isError: true);
            }
            if (state.isEditing == false && _hasUnsavedChanges) {
              _showThemedSnackBar(context, message: 'Profile updated successfully!');
              setState(() {
                _hasUnsavedChanges = false;
              });
            }
            if (state.isLoggedOut == true || state.isProfileDeleted == true) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: const SignInPage(),
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading == true && state.userEntity == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.brandPrimary));
            }
            if (state.userEntity == null) {
              return const Center(child: Text('No user data available.', style: TextStyle(color: AppColors.textSecondary)));
            }
            final user = state.userEntity!;
            final isEditing = state.isEditing ?? false;
            return Stack(
              children: [
                if (!isEditing) _buildViewMode(context, user) else _buildEditMode(context, user),
                if (state.isLoading == true && state.userEntity != null)
                  Container(
                    color: AppColors.neutralBlack.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator(color: AppColors.brandPrimary)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildViewMode(BuildContext context, UserEntity user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: AppColors.neutralDark),
            child: Column(
              children: [
                _buildRobustAvatar(user.profilePicture),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.neutralDarkGrey, AppColors.neutralDark]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.neutralLightGrey),
            ),
            child: Column(
              children: [
                _buildDetailTile(icon: Icons.person_outline, label: 'Full Name', value: user.fullName),
                _buildDivider(),
                _buildDetailTile(icon: Icons.email_outlined, label: 'Email', value: user.email),
                _buildDivider(),
                _buildDetailTile(icon: Icons.phone_outlined, label: 'Phone', value: user.phone ?? 'Not provided'),
                _buildDivider(),
                _buildDetailTile(icon: Icons.location_on_outlined, label: 'Address', value: user.address ?? 'Not provided'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _ThemedButton(
                    onPressed: () {
                      _populateControllers(user);
                      context.read<ProfileViewModel>().add(ToggleEditModeEvent());
                    },
                    label: 'Edit Profile',
                    icon: Icons.edit_outlined),
                const SizedBox(height: 12),
                _ThemedButton(
                  onPressed: () => _showLogoutConfirmationDialog(context),
                  label: 'Logout',
                  icon: Icons.logout,
                  isOutlined: true,
                ),
                const SizedBox(height: 12),
                _ThemedButton(
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  label: 'Delete Profile',
                  icon: Icons.delete_outline,
                  isOutlined: true,
                  color: AppColors.statusError,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, UserEntity user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.neutralDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _buildRobustAvatar(user.profilePicture),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(color: AppColors.brandPrimary, shape: BoxShape.circle),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: AppColors.textPrimary, size: 20),
                              onPressed: () {
                                _showThemedSnackBar(context, message: 'Image upload feature coming soon!');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap camera to change photo', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.neutralDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildTextFormField(controller: _fullNameController, focusNode: _fullNameFocus, label: 'Full Name', icon: Icons.person_outline, textInputAction: TextInputAction.next, onFieldSubmitted: (_) => _emailFocus.requestFocus(), validator: _validateFullName),
                    const SizedBox(height: 16),
                    _buildTextFormField(controller: _emailController, focusNode: _emailFocus, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, onFieldSubmitted: (_) => _phoneFocus.requestFocus(), validator: _validateEmail),
                    const SizedBox(height: 16),
                    _buildTextFormField(controller: _phoneController, focusNode: _phoneFocus, label: 'Phone (Optional)', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, onFieldSubmitted: (_) => _addressFocus.requestFocus(), validator: _validatePhone),
                    const SizedBox(height: 16),
                    _buildTextFormField(controller: _addressController, focusNode: _addressFocus, label: 'Address (Optional)', icon: Icons.location_on_outlined, maxLines: 2, textInputAction: TextInputAction.done, validator: _validateAddress),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_hasUnsavedChanges)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.brandPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.brandPrimary.withOpacity(0.3))),
                  child: const Row(children: [
                    Icon(Icons.info_outline, color: AppColors.brandPrimary, size: 18),
                    SizedBox(width: 12),
                    Expanded(child: Text('You have unsaved changes', style: TextStyle(color: AppColors.brandPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
                  ]),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ThemedButton(
                      label: 'Cancel',
                      icon: Icons.close,
                      isOutlined: true,
                      onPressed: () async {
                        if (_hasUnsavedChanges) {
                          final shouldDiscard = await _showThemedDialog<bool>(
                            context: context,
                            title: 'Discard Changes?',
                            content: 'Are you sure you want to discard your changes?',
                            actions: [
                              _ThemedDialogAction(text: 'Keep Editing', onPressed: () => Navigator.of(context).pop(false)),
                              _ThemedDialogAction(text: 'Discard', isDestructive: true, onPressed: () => Navigator.of(context).pop(true)),
                            ],
                          );
                          if (shouldDiscard == true) {
                            _resetForm(user);
                            context.read<ProfileViewModel>().add(ToggleEditModeEvent());
                          }
                        } else {
                          context.read<ProfileViewModel>().add(ToggleEditModeEvent());
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _ThemedButton(onPressed: () => _saveProfile(context, user), icon: Icons.save_outlined, label: 'Save Changes')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label, required IconData icon, FocusNode? focusNode, TextInputType? keyboardType, TextInputAction? textInputAction, int maxLines = 1, String? Function(String?)? validator, void Function(String)? onFieldSubmitted}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.neutralDarkGrey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.neutralLightGrey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.neutralLightGrey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.statusError, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.statusError, width: 2)),
        errorStyle: const TextStyle(color: AppColors.statusError, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.neutralLightGrey);
  }

  void _showThemedSnackBar(BuildContext context, {required String message, bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: AppColors.textPrimary),
            const SizedBox(width: 16),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: isError ? AppColors.statusError : AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
  }

  Future<T?> _showThemedDialog<T>({required BuildContext context, IconData? icon, Color? iconColor, required String title, required String content, required List<Widget> actions}) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.neutralDarkGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.neutralLightGrey)),
        title: Row(children: [
          if (icon != null) ...[Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 24), const SizedBox(width: 12)],
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ]),
        content: Text(content, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        actions: actions,
      ),
    );
  }
}

class _ThemedDialogAction extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isDefault;

  const _ThemedDialogAction({required this.text, required this.onPressed, this.isDestructive = false, this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.textSecondary;
    if (isDestructive) color = AppColors.statusError;
    if (isDefault) color = AppColors.brandPrimary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}

class _ThemedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool isOutlined;
  final Color? color;

  const _ThemedButton({required this.onPressed, required this.label, required this.icon, this.isOutlined = false, this.color});

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: color ?? AppColors.textSecondary,
            side: BorderSide(color: color ?? AppColors.neutralLightGrey),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.brandPrimary, AppColors.brandDark], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.textPrimary),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
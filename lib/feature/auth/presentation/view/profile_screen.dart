// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:motofix_app/app/service_locator/service_locator.dart';
// import 'package:motofix_app/core/common/shaker_detect.dart';
// import 'package:motofix_app/feature/auth/presentation/view/signin_page.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
// import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
// import '../../domain/entity/auth_entity.dart';

// class ProfileViewPage extends StatefulWidget {
//   const ProfileViewPage({super.key});

//   @override
//   State<ProfileViewPage> createState() => _ProfileViewPageState();
// }

// class _ProfileViewPageState extends State<ProfileViewPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   // Focus nodes for better form navigation
//   final _fullNameFocus = FocusNode();
//   final _emailFocus = FocusNode();
//   final _phoneFocus = FocusNode();
//   final _addressFocus = FocusNode();

//   late ShakeDetector _shakeDetector;

//   // Track if form has unsaved changes
//   bool _hasUnsavedChanges = false;
//   UserEntity? _originalUser;

//   @override
//   void initState() {
//     super.initState();

//     _shakeDetector = ShakeDetector(
//       onPhoneShake: () {
//         if (mounted) {
//           _showLogoutConfirmationDialog(context);
//         }
//       },
//     );
//     _shakeDetector.startListening();

//     // Listen to text changes to track modifications
//     _setupChangeListeners();
//   }

//   void _setupChangeListeners() {
//     _fullNameController.addListener(_onFormChanged);
//     _emailController.addListener(_onFormChanged);
//     _phoneController.addListener(_onFormChanged);
//     _addressController.addListener(_onFormChanged);
//   }

//   void _onFormChanged() {
//     if (_originalUser != null) {
//       final hasChanges = _fullNameController.text != _originalUser!.fullName ||
//           _emailController.text != _originalUser!.email ||
//           _phoneController.text != (_originalUser!.phone ?? '') ||
//           _addressController.text != (_originalUser!.address ?? '');

//       if (hasChanges != _hasUnsavedChanges) {
//         setState(() {
//           _hasUnsavedChanges = hasChanges;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _shakeDetector.stopListening();
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _fullNameFocus.dispose();
//     _emailFocus.dispose();
//     _phoneFocus.dispose();
//     _addressFocus.dispose();
//     super.dispose();
//   }

//   void _populateControllers(UserEntity user) {
//     _originalUser = user;
//     _fullNameController.text = user.fullName;
//     _emailController.text = user.email;
//     _phoneController.text = user.phone ?? '';
//     _addressController.text = user.address ?? '';
//     _hasUnsavedChanges = false;
//   }

//   // Enhanced validation methods
//   String? _validateFullName(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Full name is required';
//     }
//     if (value.trim().length < 2) {
//       return 'Full name must be at least 2 characters';
//     }
//     if (value.trim().length > 50) {
//       return 'Full name must be less than 50 characters';
//     }
//     // Check for valid characters (letters, spaces, hyphens, apostrophes)
//     if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) {
//       return 'Full name can only contain letters, spaces, hyphens, and apostrophes';
//     }
//     return null;
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     // More comprehensive email validation
//     if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
//         .hasMatch(value.trim())) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   String? _validatePhone(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return null; // Phone is optional
//     }
//     // Remove spaces and special characters for validation
//     String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
//     if (cleanPhone.length < 10) {
//       return 'Phone number must be at least 10 digits';
//     }
//     if (!RegExp(r'^[+]?[0-9]+$').hasMatch(cleanPhone)) {
//       return 'Please enter a valid phone number';
//     }
//     return null;
//   }

//   String? _validateAddress(String? value) {
//     if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
//       return 'Address must be at least 5 characters if provided';
//     }
//     return null;
//   }

//   Future<bool> _onWillPop() async {
//     if (!_hasUnsavedChanges) return true;

//     return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Unsaved Changes'),
//             content: const Text(
//                 'You have unsaved changes. Are you sure you want to leave?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Stay'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Leave'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   void _saveProfile(BuildContext context, UserEntity user) {
//     if (!_formKey.currentState!.validate()) {
//       // Scroll to first error field
//       return;
//     }

//     // Show confirmation if making significant changes
//     if (_emailController.text.trim() != user.email) {
//       _showEmailChangeConfirmation(context, user);
//     } else {
//       _performUpdate(context, user);
//     }
//   }

//   void _showEmailChangeConfirmation(BuildContext context, UserEntity user) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Email Change'),
//         content: const Text(
//             'Changing your email address may require re-verification. Do you want to continue?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _performUpdate(context, user);
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
//             child: const Text('Continue'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _performUpdate(BuildContext context, UserEntity user) {
//     final updatedUser = user.copyWith(
//       fullName: _fullNameController.text.trim(),
//       email: _emailController.text.trim(),
//       phone: _phoneController.text.trim().isEmpty
//           ? null
//           : _phoneController.text.trim(),
//       address: _addressController.text.trim().isEmpty
//           ? null
//           : _addressController.text.trim(),
//     );

//     context.read<ProfileViewModel>().add(
//           UpdateProfileEvent(userEntity: updatedUser),
//         );
//   }

//   void _resetForm(UserEntity user) {
//     _populateControllers(user);
//     _formKey.currentState?.reset();
//   }

//   void _showLogoutConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 context.read<ProfileViewModel>().add(LogoutEvent());
//               },
//               style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
//               child: const Text('Logout'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text('Delete Profile'),
//           content: const Text(
//               'Are you sure you want to delete your profile? This action cannot be undone.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 context.read<ProfileViewModel>().add(DeleteProfileEvent());
//               },
//               style: TextButton.styleFrom(foregroundColor: Colors.red),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           title: const Text('Profile'),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black87,
//           elevation: 0,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1),
//             child: Container(
//               color: Colors.grey[200],
//               height: 1,
//             ),
//           ),
//         ),
//         body: BlocConsumer<ProfileViewModel, ProfileState>(
//           listener: (context, state) {
//             if (state.onError != null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.onError!),
//                   backgroundColor: Colors.red,
//                   action: SnackBarAction(
//                     label: 'Dismiss',
//                     textColor: Colors.white,
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                     },
//                   ),
//                 ),
//               );
//             }

//             // Show success message when profile is updated
//             if (state.isEditing == false && _hasUnsavedChanges) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Profile updated successfully!'),
//                   backgroundColor: Colors.green,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//               _hasUnsavedChanges = false;
//             }

//             if (state.isLoggedOut == true || state.isProfileDeleted == true) {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(
//                   builder: (context) => BlocProvider.value(
//                     value: serviceLocator<LoginViewModel>(),
//                     child: const SignInPage(),
//                   ),
//                 ),
//                 (Route<dynamic> route) => false,
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state.isLoading == true && state.userEntity == null) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state.userEntity == null) {
//               return const Center(child: Text('No user data available.'));
//             }

//             final user = state.userEntity!;
//             final isEditing = state.isEditing ?? false;

//             return Stack(
//               children: [
//                 if (!isEditing)
//                   _buildViewMode(context, user)
//                 else
//                   _buildEditMode(context, user),
//                 if (state.isLoading == true && state.userEntity != null)
//                   Container(
//                     color: Colors.black.withOpacity(0.3),
//                     child: const Center(child: CircularProgressIndicator()),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildViewMode(BuildContext context, UserEntity user) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Profile Header
//           Container(
//             width: double.infinity,
//             color: Colors.white,
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.blue[100],
//                   backgroundImage: user.profilePicture != null
//                       ? NetworkImage(user.profilePicture!)
//                       : null,
//                   child: user.profilePicture == null
//                       ? Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Colors.blue[600],
//                         )
//                       : null,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   user.fullName,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   user.email,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Profile Details
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 _buildDetailTile(
//                     icon: Icons.person_outline,
//                     label: 'Full Name',
//                     value: user.fullName),
//                 _buildDivider(),
//                 _buildDetailTile(
//                     icon: Icons.email_outlined,
//                     label: 'Email',
//                     value: user.email),
//                 _buildDivider(),
//                 _buildDetailTile(
//                     icon: Icons.phone_outlined,
//                     label: 'Phone',
//                     value: user.phone ?? 'Not provided'),
//                 _buildDivider(),
//                 _buildDetailTile(
//                     icon: Icons.location_on_outlined,
//                     label: 'Address',
//                     value: user.address ?? 'Not provided'),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Action Buttons
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       _populateControllers(user);
//                       context
//                           .read<ProfileViewModel>()
//                           .add(ToggleEditModeEvent());
//                     },
//                     icon: const Icon(Icons.edit),
//                     label: const Text('Edit Profile'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[600],
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () => _showLogoutConfirmationDialog(context),
//                     icon: const Icon(Icons.logout),
//                     label: const Text('Logout'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.blue[600],
//                       side: BorderSide(color: Colors.blue[600]!),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     onPressed: () => _showDeleteConfirmationDialog(context),
//                     icon: const Icon(Icons.delete_outline),
//                     label: const Text('Delete Profile'),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: const BorderSide(color: Colors.red),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 32),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditMode(BuildContext context, UserEntity user) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Profile Picture Section
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.blue[100],
//                           backgroundImage: user.profilePicture != null
//                               ? NetworkImage(user.profilePicture!)
//                               : null,
//                           child: user.profilePicture == null
//                               ? Icon(
//                                   Icons.person,
//                                   size: 50,
//                                   color: Colors.blue[600],
//                                 )
//                               : null,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.blue[600],
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 // TODO: Implement image picker
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                         'Image upload feature coming soon!'),
//                                     duration: Duration(seconds: 2),
//                                   ),
//                                 );
//                               },
//                             ),),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Tap to change photo',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Form Fields
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     _buildTextFormField(
//                       controller: _fullNameController,
//                       focusNode: _fullNameFocus,
//                       label: 'Full Name',
//                       icon: Icons.person_outline,
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) => _emailFocus.requestFocus(),
//                       validator: _validateFullName,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       controller: _emailController,
//                       focusNode: _emailFocus,
//                       label: 'Email',
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
//                       validator: _validateEmail,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       controller: _phoneController,
//                       focusNode: _phoneFocus,
//                       label: 'Phone (Optional)',
//                       icon: Icons.phone_outlined,
//                       keyboardType: TextInputType.phone,
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) => _addressFocus.requestFocus(),
//                       validator: _validatePhone,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextFormField(
//                       controller: _addressController,
//                       focusNode: _addressFocus,
//                       label: 'Address (Optional)',
//                       icon: Icons.location_on_outlined,
//                       maxLines: 2,
//                       textInputAction: TextInputAction.done,
//                       validator: _validateAddress,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Unsaved changes indicator
//               if (_hasUnsavedChanges)
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.orange[300]!, width: 1),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.info_outline,
//                           color: Colors.orange[700], size: 18),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           'You have unsaved changes',
//                           style: TextStyle(
//                             color: Colors
//                                 .orange[800], // Darker text for better contrast
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               const SizedBox(height: 24),

//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () async {
//                         if (_hasUnsavedChanges) {
//                           final shouldDiscard = await showDialog<bool>(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Discard Changes'),
//                               content: const Text(
//                                   'Are you sure you want to discard your changes?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(false),
//                                   child: const Text('Keep Editing'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.of(context).pop(true),
//                                   style: TextButton.styleFrom(
//                                       foregroundColor: Colors.red),
//                                   child: const Text('Discard'),
//                                 ),
//                               ],
//                             ),
//                           );

//                           if (shouldDiscard == true) {
//                             _resetForm(user);
//                             context
//                                 .read<ProfileViewModel>()
//                                 .add(ToggleEditModeEvent());
//                           }
//                         } else {
//                           context
//                               .read<ProfileViewModel>()
//                               .add(ToggleEditModeEvent());
//                         }
//                       },
//                       icon: const Icon(Icons.close),
//                       label: const Text('Cancel'),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton.icon(onPressed: () => _saveProfile(context, user),
//                       icon: const Icon(Icons.save),
//                       label: const Text('Save Changes'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue[600],
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailTile({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: Colors.grey[600],
//             size: 20,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     FocusNode? focusNode,
//     TextInputType? keyboardType,
//     TextInputAction? textInputAction,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//     void Function(String)? onFieldSubmitted,
//   }) {
//     return TextFormField(
//       controller: controller,
//       focusNode: focusNode,
//       keyboardType: keyboardType,
//       textInputAction: textInputAction,
//       maxLines: maxLines,
//       validator: validator,
//       onFieldSubmitted: onFieldSubmitted,
//       style: const TextStyle(
//         color: Colors.black87, // Ensure text is dark and visible
//         fontSize: 16,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: Colors.grey[600], // Clear label color
//           fontSize: 16,
//         ),
//         hintStyle: TextStyle(
//           color: Colors.grey[400], // Lighter hint text
//           fontSize: 16,
//         ),
//         prefixIcon: Icon(
//           icon,
//           color: Colors.grey[600], // Consistent icon color
//         ),
//         filled: true,
//         fillColor: Colors.grey[50], // Light background for contrast
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.red, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
//         ),
//         errorStyle: const TextStyle(
//           color: Colors.red, // Clear error text color
//           fontSize: 12,
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(
//       height: 1,
//       color: Colors.grey[200],
//       indent: 56,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motofix_app/app/service_locator/service_locator.dart';
import 'package:motofix_app/core/common/shaker_detect.dart';
import 'package:motofix_app/feature/auth/presentation/view/signin_page.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_event.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_state.dart';
import 'package:motofix_app/feature/auth/presentation/view_model/profile_view_model/profile_view_model.dart';
import 'package:motofix_app/core/common/app_colors.dart';
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

  // Focus nodes for better form navigation
  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _addressFocus = FocusNode();

  late ShakeDetector _shakeDetector;

  // Track if form has unsaved changes
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

    // Listen to text changes to track modifications
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

  // Enhanced validation methods
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Full name must be less than 50 characters';
    }
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value.trim())) {
      return 'Full name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // More comprehensive email validation
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    // Remove spaces and special characters for validation
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanPhone.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[+]?[0-9]+$').hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 5) {
      return 'Address must be at least 5 characters if provided';
    }
    return null;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _saveProfile(BuildContext context, UserEntity user) {
    if (!_formKey.currentState!.validate()) {
      // Scroll to first error field
      return;
    }

    // Show confirmation if making significant changes
    if (_emailController.text.trim() != user.email) {
      _showEmailChangeConfirmation(context, user);
    } else {
      _performUpdate(context, user);
    }
  }

  void _showEmailChangeConfirmation(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Change'),
        content: const Text(
            'Changing your email address may require re-verification. Do you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performUpdate(context, user);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _performUpdate(BuildContext context, UserEntity user) {
    final updatedUser = user.copyWith(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
    );

    context.read<ProfileViewModel>().add(
          UpdateProfileEvent(userEntity: updatedUser),
        );
  }

  void _resetForm(UserEntity user) {
    _populateControllers(user);
    _formKey.currentState?.reset();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProfileViewModel>().add(LogoutEvent());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue[600]),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text(
              'Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProfileViewModel>().add(DeleteProfileEvent());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // --- NEW WIDGET: A robust avatar that handles loading and errors ---
  Widget _buildRobustAvatar(String? imageUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.accentBlue,
      child: ClipOval(
        child: Image.network(
          imageUrl ?? _defaultAvatarUrl,
          fit: BoxFit.cover,
          width: 100, // This should be radius * 2
          height: 100, // This should be radius * 2
          // Show a loading spinner while the image is downloading
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child; // Image is loaded
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          },
          // Show a person icon if the image fails to load
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            );
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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey[200],
              height: 1,
            ),
          ),
        ),
        body: BlocConsumer<ProfileViewModel, ProfileState>(
          listener: (context, state) {
            if (state.onError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.onError!),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }

            // Show success message when profile is updated
            if (state.isEditing == false && _hasUnsavedChanges) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
              _hasUnsavedChanges = false;
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state.userEntity == null) {
              return const Center(child: Text('No user data available.'));
            }

            final user = state.userEntity!;
            final isEditing = state.isEditing ?? false;

            return Stack(
              children: [
                if (!isEditing)
                  _buildViewMode(context, user)
                else
                  _buildEditMode(context, user),
                if (state.isLoading == true && state.userEntity != null)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
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
          // Profile Header
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // --- MODIFIED: Using the new robust avatar widget ---
                _buildRobustAvatar(user.profilePicture),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Profile Details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDetailTile(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    value: user.fullName),
                _buildDivider(),
                _buildDetailTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email),
                _buildDivider(),
                _buildDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone ?? 'Not provided'),
                _buildDivider(),
                _buildDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: user.address ?? 'Not provided'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _populateControllers(user);
                      context
                          .read<ProfileViewModel>()
                          .add(ToggleEditModeEvent());
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutConfirmationDialog(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[600],
                      side: BorderSide(color: Colors.blue[600]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
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
              // Profile Picture Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // --- MODIFIED: Using the new robust avatar widget ---
                        _buildRobustAvatar(user.profilePicture),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                // TODO: Implement image picker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Image upload feature coming soon!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to change photo',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Form Fields
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextFormField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocus,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                      validator: _validateFullName,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      label: 'Phone (Optional)',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => _addressFocus.requestFocus(),
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _addressController,
                      focusNode: _addressFocus,
                      label: 'Address (Optional)',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      validator: _validateAddress,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Unsaved changes indicator
              if (_hasUnsavedChanges)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.orange[700], size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You have unsaved changes',
                          style: TextStyle(
                            color: Colors
                                .orange[800], // Darker text for better contrast
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (_hasUnsavedChanges) {
                          final shouldDiscard = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Discard Changes'),
                              content: const Text(
                                  'Are you sure you want to discard your changes?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Keep Editing'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  child: const Text('Discard'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDiscard == true) {
                            _resetForm(user);
                            context
                                .read<ProfileViewModel>()
                                .add(ToggleEditModeEvent());
                          }
                        } else {
                          context
                              .read<ProfileViewModel>()
                              .add(ToggleEditModeEvent());
                        }
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(onPressed: () => _saveProfile(context, user),
                      icon: const Icon(Icons.save),
                      label: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: Colors.black87, // Ensure text is dark and visible
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600], // Clear label color
          fontSize: 16,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400], // Lighter hint text
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey[600], // Consistent icon color
        ),
        filled: true,
        fillColor: Colors.grey[50], // Light background for contrast
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(
          color: Colors.red, // Clear error text color
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 56,
    );
  }
}
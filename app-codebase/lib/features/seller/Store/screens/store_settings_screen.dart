import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/store_controller.dart';
import '../widgets/basic_info_tab.dart';
import '../widgets/shipping_tab.dart';
import '../widgets/policies_tab.dart';

/// A premium, beautiful Store Settings editor screen for sellers.
/// Features a modular TabBar interface (Basic, Shipping, Policies), 
/// dynamic image picker for the cover banner, and reactive model updates.
/// Leverages modular, separated tab widgets to achieve extreme maintainability.
class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StoreController _storeController = Get.find<StoreController>();

  // Text controllers for Basic settings
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Text controllers for Shipping settings
  late TextEditingController _shippingController;

  // Text controllers for Policies settings
  late TextEditingController _returnController;
  late TextEditingController _termsController;

  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    final store = _storeController.store.value;
    
    // Initialize editing controllers with current reactive store state
    _nameController = TextEditingController(text: store?.name ?? 'My Store');
    _categoryController = TextEditingController(text: store?.category ?? '');
    _descriptionController = TextEditingController(text: store?.description ?? '');
    _emailController = TextEditingController(text: store?.contactEmail ?? '');
    _phoneController = TextEditingController(text: store?.phoneNumber ?? '');
    
    _shippingController = TextEditingController(text: store?.shippingPolicy ?? '');
    
    _returnController = TextEditingController(text: store?.returnPolicy ?? '');
    _termsController = TextEditingController(text: store?.termsOfService ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shippingController.dispose();
    _returnController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  /// Pick banner image from local system gallery
  Future<void> _pickBannerImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        _storeController.updateBanner(image.path);
      }
    } catch (e) {
      debugPrint('Error picking store banner image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick banner image. Please grant storage access.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Save changes reactively and return back
  void _saveChanges() async {
    setState(() => _isSaving = true);

    // Simulate API save delay
    await Future.delayed(const Duration(milliseconds: 600));

    _storeController.saveStoreSettings(
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      description: _descriptionController.text.trim(),
      contactEmail: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      shippingPolicy: _shippingController.text.trim(),
      returnPolicy: _returnController.text.trim(),
      termsOfService: _termsController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Store Settings saved successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Styling attributes
    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Store Settings',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: labelColor,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2,
          dividerColor: borderColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          tabs: const [
            Tab(text: 'Basic'),
            Tab(text: 'Shipping'),
            Tab(text: 'Policies'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Basic Info Tab (using extracted widget)
                BasicInfoTab(
                  storeController: _storeController,
                  nameController: _nameController,
                  categoryController: _categoryController,
                  descriptionController: _descriptionController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  onPickImage: _pickBannerImage,
                ),
                
                // 2. Shipping Tab (using extracted widget)
                ShippingTab(
                  shippingController: _shippingController,
                ),
                
                // 3. Policies Tab (using extracted widget)
                PoliciesTab(
                  returnController: _returnController,
                  termsController: _termsController,
                ),
              ],
            ),
          ),
          
          // Persistent Bottom Actions Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

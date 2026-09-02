import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/utils/adaptive_date_picker.dart';
import 'package:home_sync/core/utils/currency_input_formatter.dart';
import 'package:home_sync/core/widgets/app_card.dart';

/// Widget Khối Bảo Hành & Mua Hàng với Date Inputs và Smart Banking Quick Amount Multipliers
class ItemWarrantyPurchaseCard extends StatefulWidget {
  const ItemWarrantyPurchaseCard({
    super.key,
    required this.purchaseDate,
    required this.warrantyExpiryDate,
    required this.warrantyMonths,
    required this.priceController,
    required this.storeController,
    required this.supportPhoneController,
    required this.onPurchaseDateChanged,
    required this.onWarrantyExpiryDateChanged,
    required this.onWarrantyMonthsChanged,
  });

  final DateTime purchaseDate;
  final DateTime warrantyExpiryDate;
  final int warrantyMonths;
  final TextEditingController priceController;
  final TextEditingController storeController;
  final TextEditingController supportPhoneController;

  final ValueChanged<DateTime> onPurchaseDateChanged;
  final ValueChanged<DateTime> onWarrantyExpiryDateChanged;
  final ValueChanged<int> onWarrantyMonthsChanged;

  @override
  State<ItemWarrantyPurchaseCard> createState() => _ItemWarrantyPurchaseCardState();
}

class _ItemWarrantyPurchaseCardState extends State<ItemWarrantyPurchaseCard> {
  static const List<int> _warrantyDurationPresets = [6, 12, 18, 24, 36, 60];

  static const List<String> _quickStores = [
    'Điện máy Xanh',
    'Shopee',
    'Lazada',
    'CellphoneS',
    'FPT Shop',
    'Nguyễn Kim',
    'MediaMart',
    'Tiki',
  ];

  final FocusNode _priceFocusNode = FocusNode();
  String _priceInWords = '';
  List<double> _smartPriceSuggestions = [];
  bool _isApplyingSuggestion = false;

  @override
  void initState() {
    super.initState();
    _updatePriceInWords();
    widget.priceController.addListener(_onPriceChanged);
    _priceFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_onPriceChanged);
    _priceFocusNode.removeListener(_onFocusChanged);
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_priceFocusNode.hasFocus) {
      if (_smartPriceSuggestions.isNotEmpty || _priceInWords.isNotEmpty) {
        setState(() {
          _smartPriceSuggestions = [];
          _priceInWords = '';
        });
      }
    } else {
      _updatePriceInWords();
    }
  }

  void _onPriceChanged() {
    if (_isApplyingSuggestion) {
      _isApplyingSuggestion = false;
      return;
    }
    _updatePriceInWords();
  }

  void _updatePriceInWords() {
    final clean = widget.priceController.text.replaceAll('.', '').replaceAll(',', '');
    final num = double.tryParse(clean);
    if (num != null && num > 0) {
      final words = ThousandsSeparatorInputFormatter.formatVndCompact(num);
      final suggestions = _priceFocusNode.hasFocus ? _generateSmartSuggestions(num) : <double>[];
      setState(() {
        _priceInWords = _priceFocusNode.hasFocus ? words : '';
        _smartPriceSuggestions = suggestions;
      });
    } else {
      if (_priceInWords.isNotEmpty || _smartPriceSuggestions.isNotEmpty) {
        setState(() {
          _priceInWords = '';
          _smartPriceSuggestions = [];
        });
      }
    }
  }

  /// Tạo danh sách gợi ý số tiền nhân nhanh phong cách Ngân Hàng (VD: gõ 2 -> 20k, 200k, 2tr, 20tr, 200tr)
  List<double> _generateSmartSuggestions(double base) {
    final List<double> list = [];
    if (base <= 0) return list;

    // Các mốc nhân chuẩn theo hàng đơn vị/chục/trăm/nghìn/triệu
    final multipliers = [10, 100, 1000, 10000, 100000, 1000000, 10000000];
    for (final m in multipliers) {
      final val = base * m;
      if (val >= 10000 && val <= 10000000000) {
        if (!list.contains(val)) {
          list.add(val);
        }
      }
    }
    // Giữ tối đa 5 gợi ý phù hợp nhất
    if (list.length > 5) {
      return list.sublist(0, 5);
    }
    return list;
  }

  void _applySuggestedPrice(double amount) {
    final formatted = NumberFormat('#,###', 'vi_VN').format(amount).replaceAll(',', '.');
    _isApplyingSuggestion = true;
    setState(() {
      _smartPriceSuggestions = [];
      _priceInWords = ''; // Ẩn cả dòng đọc tiền khi đã hoàn tất
    });
    widget.priceController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    // Tự động hoàn tất, hạ bàn phím và bỏ focus
    _priceFocusNode.unfocus();
  }

  InputDecoration _buildDecoration({
    required BuildContext context,
    required String labelText,
    String? hintText,
    String? prefixText,
    String? helperText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.grey.shade900 : Colors.grey.shade50;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixText: prefixText,
      helperText: helperText,
      helperMaxLines: 3,
      helperStyle: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
      counterText: '', // Ẩn bộ đếm ký tự để giữ form sạch sẽ
      isDense: true,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  Widget _buildDateInputBox({
    required BuildContext context,
    required String label,
    required DateTime date,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.grey.shade900 : Colors.grey.shade50;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 18, color: accentColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(widget.warrantyExpiryDate.year, widget.warrantyExpiryDate.month, widget.warrantyExpiryDate.day);
    final daysRemaining = expiry.difference(today).inDays;
    final isExpired = daysRemaining < 0;
    final isExpiringSoon = !isExpired && daysRemaining <= 30;

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bảo hành & Mua hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),

          // 1. Hai ô Ngày mua & Ngày hết hạn bảo hành song song (Dual-Date Box)
          Row(
            children: [
              Expanded(
                child: _buildDateInputBox(
                  context: context,
                  label: 'Ngày mua hàng',
                  date: widget.purchaseDate,
                  icon: LucideIcons.calendar,
                  accentColor: AppColors.primary,
                  onTap: () async {
                    final picked = await showAdaptiveAppDatePicker(
                      context: context,
                      title: 'Chọn ngày mua hàng',
                      initialDate: widget.purchaseDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      widget.onPurchaseDateChanged(picked);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateInputBox(
                  context: context,
                  label: 'Hạn bảo hành',
                  date: widget.warrantyExpiryDate,
                  icon: LucideIcons.shieldCheck,
                  accentColor: isExpired
                      ? AppColors.error
                      : (isExpiringSoon ? AppColors.warning : AppColors.statusGood),
                  onTap: () async {
                    final picked = await showAdaptiveAppDatePicker(
                      context: context,
                      title: 'Chọn hạn bảo hành',
                      initialDate: widget.warrantyExpiryDate,
                      firstDate: widget.purchaseDate,
                      lastDate: DateTime(2050),
                    );
                    if (picked != null) {
                      widget.onWarrantyExpiryDateChanged(picked);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Thẻ Trạng Thái Bảo Hành Thời Gian Thực (Live Status Pill)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isExpired
                  ? AppColors.statusDangerBg
                  : (isExpiringSoon ? AppColors.statusWarningBg : AppColors.statusGoodBg),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isExpired
                    ? AppColors.error.withValues(alpha: 0.25)
                    : (isExpiringSoon
                        ? AppColors.warning.withValues(alpha: 0.25)
                        : AppColors.statusGood.withValues(alpha: 0.25)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isExpired
                      ? LucideIcons.shieldAlert
                      : (isExpiringSoon ? LucideIcons.shieldAlert : LucideIcons.shieldCheck),
                  size: 15,
                  color: isExpired
                      ? AppColors.error
                      : (isExpiringSoon ? AppColors.warning : AppColors.statusGood),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isExpired
                        ? 'Đã hết hạn bảo hành'
                        : (daysRemaining == 0
                            ? 'Hết hạn bảo hành vào hôm nay'
                            : 'Còn hiệu lực: $daysRemaining ngày (${widget.warrantyMonths} tháng bảo hành)'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isExpired
                          ? AppColors.error
                          : (isExpiringSoon ? AppColors.warning : AppColors.statusGood),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Thời hạn bảo hành & ListView Ngang 1 chạm
          const Text('Chọn nhanh thời hạn bảo hành:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              scrollCacheExtent: const ScrollCacheExtent.pixels(200),
              itemCount: _warrantyDurationPresets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final months = _warrantyDurationPresets[index];
                final isSelected = widget.warrantyMonths == months;
                final label = months % 12 == 0 ? '${months ~/ 12} năm' : '$months tháng';
                return ChoiceChip(
                  showCheckmark: false,
                  label: Text(label, style: const TextStyle(fontSize: 12)),
                  selected: isSelected,
                  onSelected: (_) => widget.onWarrantyMonthsChanged(months),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 4. Giá mua (Bỏ ký hiệu đ, có tự động format và trợ lý đọc số tiền)
          TextFormField(
            controller: widget.priceController,
            focusNode: _priceFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 15,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
              ThousandsSeparatorInputFormatter(),
            ],
            decoration: _buildDecoration(
              context: context,
              labelText: 'Giá mua (VNĐ)',
              hintText: 'VD: 25.000.000',
              helperText: _priceInWords.isNotEmpty ? _priceInWords : null,
            ),
          ),

          // 4b. Gợi Ý Số Tiền Nhân Nhanh (Smart Banking Multipliers)
          if (_smartPriceSuggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                scrollCacheExtent: const ScrollCacheExtent.pixels(200),
                itemCount: _smartPriceSuggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final amount = _smartPriceSuggestions[index];
                  final formattedText = NumberFormat('#,###', 'vi_VN').format(amount).replaceAll(',', '.');

                  return ActionChip(
                    label: Text(
                      formattedText,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => _applySuggestedPrice(amount),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),

          // 5. Nơi mua & Quick Store Chips
          TextFormField(
            controller: widget.storeController,
            maxLength: 100,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Nơi mua',
              hintText: 'VD: Điện máy Xanh, Shopee...',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              scrollCacheExtent: const ScrollCacheExtent.pixels(200),
              itemCount: _quickStores.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final store = _quickStores[index];
                return ActionChip(
                  label: Text(store, style: const TextStyle(fontSize: 12)),
                  padding: EdgeInsets.zero,
                  onPressed: () => widget.storeController.text = store,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 6. Hotline bảo hành hãng
          TextFormField(
            controller: widget.supportPhoneController,
            maxLength: 20,
            keyboardType: TextInputType.phone,
            decoration: _buildDecoration(
              context: context,
              labelText: 'Hotline bảo hành hãng',
              hintText: '1800-xxxx',
            ),
          ),
        ],
      ),
    );
  }
}

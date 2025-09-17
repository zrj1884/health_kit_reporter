import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../services/health_icon_service.dart';
import '../services/health_sync_service.dart';
import '../components/ios_snackbar.dart';

class HealthFilterScreen extends StatefulWidget {
  final String? initialIdentifier;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool? initialIsValid;
  final String? initialSourceName;

  const HealthFilterScreen({
    super.key,
    this.initialIdentifier,
    this.initialStartDate,
    this.initialEndDate,
    this.initialIsValid,
    this.initialSourceName,
  });

  @override
  State<HealthFilterScreen> createState() => _HealthFilterScreenState();
}

class _HealthFilterScreenState extends State<HealthFilterScreen> {
  String? _selectedIdentifier;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _isValidFilter;
  String? _selectedSourceName;
  final int maxShowCount = 8;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sourceSearchController = TextEditingController();
  final HealthSyncService _syncService = HealthSyncService();
  List<String> _availableSourceNames = [];

  @override
  void initState() {
    super.initState();
    _selectedIdentifier = widget.initialIdentifier;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _isValidFilter = widget.initialIsValid;
    _selectedSourceName = widget.initialSourceName;
    _loadSourceNames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sourceSearchController.dispose();
    super.dispose();
  }

  /// 加载可用的数据来源
  Future<void> _loadSourceNames() async {
    try {
      final sourceNames = await _syncService.getUniqueSourceNames();
      setState(() {
        _availableSourceNames = sourceNames;
      });
    } catch (e) {
      if (mounted) {
        IOSSnackBar.showError(context, message: '加载数据来源失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '过滤条件',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('数据类型'),
              const SizedBox(height: 8),
              _buildDataTypeSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('数据来源'),
              const SizedBox(height: 8),
              _buildSourceNameSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('日期范围'),
              const SizedBox(height: 8),
              _buildDateRangeSelector(),
              const SizedBox(height: 24),
              _buildSectionTitle('有效性'),
              const SizedBox(height: 8),
              _buildValiditySelector(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('重置', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('应用', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建章节标题
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  /// 构建数据类型选择器
  Widget _buildDataTypeSelector() {
    return DropdownButton2<String>(
      value: _selectedIdentifier,
      hint: const Text('选择数据类型', style: TextStyle(fontSize: 16, color: Colors.grey)),
      items: [
        const DropdownMenuItem(value: null, child: Text('全部')),
        ..._getGroupedIdentifierItems(),
      ],
      onChanged: (value) {
        // 忽略分类标题的选择
        if (value != null && value.startsWith('__CATEGORY_')) {
          return;
        }
        setState(() {
          _selectedIdentifier = value;
        });
      },
      buttonStyleData: ButtonStyleData(
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        elevation: 0,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        elevation: 0, // 设置为0，因为我们使用自定义的boxShadow
        offset: const Offset(0, -8),
        maxHeight: maxShowCount * 40, // 当items超过n个时，限制最大高度为 (n * 40)px
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all(6),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.symmetric(horizontal: 16)),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 20,
        iconEnabledColor: Colors.grey,
        iconDisabledColor: Colors.grey,
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: _searchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 60,
          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              hintText: '搜索数据类型...',
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(Icons.clear, color: Colors.grey),
                    )
                  : null,
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          if (item.value == null) {
            return false;
          }
          final name = HealthIconService.getDisplayNameForIdentifier(item.value!);
          return name.toLowerCase().contains(searchValue.toLowerCase());
        },
      ),
      onMenuStateChange: (isOpen) {
        // 可以在这里处理菜单状态变化
        if (!isOpen) {
          _searchController.clear();
        }
      },
    );
  }

  /// 构建数据来源选择器
  Widget _buildSourceNameSelector() {
    return DropdownButton2<String>(
      value: _selectedSourceName,
      hint: const Text('选择数据来源', style: TextStyle(fontSize: 16, color: Colors.grey)),
      items: [
        const DropdownMenuItem(value: null, child: Text('全部')),
        ..._getGroupedSourceNameItems(),
      ],
      onChanged: (value) {
        // 忽略分类标题的选择
        if (value != null && value.startsWith('__CATEGORY_')) {
          return;
        }
        setState(() {
          _selectedSourceName = value;
        });
      },
      buttonStyleData: ButtonStyleData(
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        elevation: 0,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        elevation: 8,
        offset: const Offset(0, -8),
      ),
      menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.symmetric(horizontal: 16)),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 20,
        iconEnabledColor: Colors.grey,
        iconDisabledColor: Colors.grey,
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: _sourceSearchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 60,
          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: _sourceSearchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              hintText: '搜索数据来源...',
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: _sourceSearchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _sourceSearchController.clear();
                      },
                      icon: const Icon(Icons.clear, color: Colors.grey),
                    )
                  : null,
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          if (item.value == null) {
            return false;
          }
          return item.value!.toLowerCase().contains(searchValue.toLowerCase());
        },
      ),
      onMenuStateChange: (isOpen) {
        // 可以在这里处理菜单状态变化
        if (!isOpen) {
          _sourceSearchController.clear();
        }
      },
    );
  }

  /// 构建日期范围选择器
  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: _buildDateButton(label: '开始日期', date: _startDate, onTap: () => _selectDate(true)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateButton(label: '结束日期', date: _endDate, onTap: () => _selectDate(false)),
              ),
            ],
          ),
        ),
        if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!))
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFF3B30).withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 16, color: const Color(0xFFFF3B30)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text('开始日期不能晚于结束日期', style: TextStyle(color: const Color(0xFFFF3B30), fontSize: 12)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// 构建日期按钮
  Widget _buildDateButton({required String label, required DateTime? date, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 20, color: date != null ? Colors.blue : Colors.grey.shade400),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    date?.toString().substring(0, 10) ?? label,
                    style: TextStyle(color: date != null ? Colors.black87 : Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建有效性选择器
  Widget _buildValiditySelector() {
    return DropdownButton2<bool>(
      value: _isValidFilter,
      hint: const Text('选择有效性', style: TextStyle(fontSize: 16, color: Colors.grey)),
      items: const [
        DropdownMenuItem(value: null, child: Text('全部')),
        DropdownMenuItem(value: true, child: Text('有效')),
        DropdownMenuItem(value: false, child: Text('无效')),
      ],
      onChanged: (value) {
        setState(() {
          _isValidFilter = value;
        });
      },
      buttonStyleData: ButtonStyleData(
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        elevation: 0,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        elevation: 8,
        offset: const Offset(0, -8),
      ),
      menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.symmetric(horizontal: 16)),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 20,
        iconEnabledColor: Colors.grey,
        iconDisabledColor: Colors.grey,
      ),
    );
  }

  /// 选择日期
  Future<void> _selectDate(bool isStartDate) async {
    final currentDate = isStartDate ? _startDate : _endDate;
    final date = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.blue)),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  /// 应用过滤条件
  void _applyFilters() {
    // 验证日期范围
    if (_startDate != null && _endDate != null && _startDate!.isAfter(_endDate!)) {
      IOSSnackBar.showError(context, message: '开始日期不能晚于结束日期');
      return;
    }

    // 返回过滤条件
    Navigator.pop(context, {
      'identifier': _selectedIdentifier,
      'startDate': _startDate,
      'endDate': _endDate,
      'isValid': _isValidFilter,
      'sourceName': _selectedSourceName,
    });
  }

  /// 重置过滤条件
  void _resetFilters() {
    setState(() {
      _selectedIdentifier = null;
      _startDate = null;
      _endDate = null;
      _isValidFilter = null;
      _selectedSourceName = null;
    });
  }

  /// 获取按分类组织的标识符下拉菜单项
  List<DropdownMenuItem<String>> _getGroupedIdentifierItems() {
    final Map<String, List<String>> groupedIdentifiers = {
      '活动': [
        'HKQuantityTypeIdentifierActiveEnergyBurned',
        'HKQuantityTypeIdentifierAppleExerciseTime',
        'HKQuantityTypeIdentifierAppleMoveTime',
        'HKQuantityTypeIdentifierAppleStandTime',
        'HKQuantityTypeIdentifierAppleWalkingSteadiness',
        'HKQuantityTypeIdentifierBasalEnergyBurned',
        'HKQuantityTypeIdentifierCrossCountrySkiingSpeed',
        'HKQuantityTypeIdentifierCyclingCadence',
        'HKQuantityTypeIdentifierCyclingFunctionalThresholdPower',
        'HKQuantityTypeIdentifierCyclingPower',
        'HKQuantityTypeIdentifierCyclingSpeed',
        'HKQuantityTypeIdentifierDistanceCrossCountrySkiing',
        'HKQuantityTypeIdentifierDistanceCycling',
        'HKQuantityTypeIdentifierDistanceDownhillSnowSports',
        'HKQuantityTypeIdentifierDistancePaddleSports',
        'HKQuantityTypeIdentifierDistanceRowing',
        'HKQuantityTypeIdentifierDistanceSkatingSports',
        'HKQuantityTypeIdentifierDistanceSwimming',
        'HKQuantityTypeIdentifierDistanceWalkingRunning',
        'HKQuantityTypeIdentifierDistanceWheelchair',
        'HKQuantityTypeIdentifierEstimatedWorkoutEffortScore',
        'HKQuantityTypeIdentifierFlightsClimbed',
        'HKQuantityTypeIdentifierNikeFuel',
        'HKQuantityTypeIdentifierPaddleSportsSpeed',
        'HKQuantityTypeIdentifierPhysicalEffort',
        'HKQuantityTypeIdentifierPushCount',
        'HKQuantityTypeIdentifierRowingSpeed',
        'HKQuantityTypeIdentifierRunningGroundContactTime',
        'HKQuantityTypeIdentifierRunningPower',
        'HKQuantityTypeIdentifierRunningSpeed',
        'HKQuantityTypeIdentifierRunningStrideLength',
        'HKQuantityTypeIdentifierRunningVerticalOscillation',
        'HKQuantityTypeIdentifierSixMinuteWalkTestDistance',
        'HKQuantityTypeIdentifierStairAscentSpeed',
        'HKQuantityTypeIdentifierStairDescentSpeed',
        'HKQuantityTypeIdentifierStepCount',
        'HKQuantityTypeIdentifierSwimmingStrokeCount',
        'HKQuantityTypeIdentifierTimeInDaylight',
        'HKQuantityTypeIdentifierUnderwaterDepth',
        'HKQuantityTypeIdentifierUVExposure',
        'HKQuantityTypeIdentifierWaterTemperature',
        'HKQuantityTypeIdentifierWorkoutEffortScore',
      ],
      '心脏': [
        'HKQuantityTypeIdentifierAtrialFibrillationBurden',
        'HKQuantityTypeIdentifierHeartRate',
        'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute',
        'HKQuantityTypeIdentifierHeartRateVariabilitySDNN',
        'HKQuantityTypeIdentifierPeripheralPerfusionIndex',
        'HKQuantityTypeIdentifierRestingHeartRate',
        'HKQuantityTypeIdentifierVO2Max',
        'HKQuantityTypeIdentifierWalkingHeartRateAverage',
      ],
      '身体': [
        'HKQuantityTypeIdentifierAppleSleepingBreathingDisturbances',
        'HKQuantityTypeIdentifierAppleSleepingWristTemperature',
        'HKQuantityTypeIdentifierBasalBodyTemperature',
        'HKQuantityTypeIdentifierBodyFatPercentage',
        'HKQuantityTypeIdentifierBodyMass',
        'HKQuantityTypeIdentifierBodyMassIndex',
        'HKQuantityTypeIdentifierBodyTemperature',
        'HKQuantityTypeIdentifierHeight',
        'HKQuantityTypeIdentifierLeanBodyMass',
        'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages',
        'HKQuantityTypeIdentifierNumberOfTimesFallen',
        'HKQuantityTypeIdentifierWaistCircumference',
      ],
      '睡眠': ['HKCategoryTypeIdentifierSleepAnalysis', 'HKCategoryTypeIdentifierSleepChanges'],
      '营养': [
        'HKQuantityTypeIdentifierDietaryBiotin',
        'HKQuantityTypeIdentifierDietaryCaffeine',
        'HKQuantityTypeIdentifierDietaryCalcium',
        'HKQuantityTypeIdentifierDietaryCarbohydrates',
        'HKQuantityTypeIdentifierDietaryChloride',
        'HKQuantityTypeIdentifierDietaryCholesterol',
        'HKQuantityTypeIdentifierDietaryChromium',
        'HKQuantityTypeIdentifierDietaryCopper',
        'HKQuantityTypeIdentifierDietaryEnergyConsumed',
        'HKQuantityTypeIdentifierDietaryFatMonounsaturated',
        'HKQuantityTypeIdentifierDietaryFatPolyunsaturated',
        'HKQuantityTypeIdentifierDietaryFatSaturated',
        'HKQuantityTypeIdentifierDietaryFatTotal',
        'HKQuantityTypeIdentifierDietaryFiber',
        'HKQuantityTypeIdentifierDietaryFolate',
        'HKQuantityTypeIdentifierDietaryIodine',
        'HKQuantityTypeIdentifierDietaryIron',
        'HKQuantityTypeIdentifierDietaryMagnesium',
        'HKQuantityTypeIdentifierDietaryManganese',
        'HKQuantityTypeIdentifierDietaryMolybdenum',
        'HKQuantityTypeIdentifierDietaryNiacin',
        'HKQuantityTypeIdentifierDietaryPantothenicAcid',
        'HKQuantityTypeIdentifierDietaryPhosphorus',
        'HKQuantityTypeIdentifierDietaryPotassium',
        'HKQuantityTypeIdentifierDietaryProtein',
        'HKQuantityTypeIdentifierDietaryRiboflavin',
        'HKQuantityTypeIdentifierDietarySelenium',
        'HKQuantityTypeIdentifierDietarySodium',
        'HKQuantityTypeIdentifierDietarySugar',
        'HKQuantityTypeIdentifierDietaryThiamin',
        'HKQuantityTypeIdentifierDietaryVitaminA',
        'HKQuantityTypeIdentifierDietaryVitaminB12',
        'HKQuantityTypeIdentifierDietaryVitaminB6',
        'HKQuantityTypeIdentifierDietaryVitaminC',
        'HKQuantityTypeIdentifierDietaryVitaminD',
        'HKQuantityTypeIdentifierDietaryVitaminE',
        'HKQuantityTypeIdentifierDietaryVitaminK',
        'HKQuantityTypeIdentifierDietaryWater',
        'HKQuantityTypeIdentifierDietaryZinc',
      ],
      '生命体征': [
        'HKQuantityTypeIdentifierBloodAlcoholContent',
        'HKQuantityTypeIdentifierBloodGlucose',
        'HKQuantityTypeIdentifierBloodPressureDiastolic',
        'HKQuantityTypeIdentifierBloodPressureSystolic',
        'HKQuantityTypeIdentifierForcedExpiratoryVolume1',
        'HKQuantityTypeIdentifierForcedVitalCapacity',
        'HKQuantityTypeIdentifierOxygenSaturation',
        'HKQuantityTypeIdentifierPeakExpiratoryFlowRate',
        'HKQuantityTypeIdentifierRespiratoryRate',
      ],
      '听力': [
        'HKQuantityTypeIdentifierEnvironmentalAudioExposure',
        'HKQuantityTypeIdentifierEnvironmentalSoundReduction',
        'HKQuantityTypeIdentifierHeadphoneAudioExposure',
      ],
      '其他健康指标': [
        'HKQuantityTypeIdentifierElectrodermalActivity',
        'HKQuantityTypeIdentifierInhalerUsage',
        'HKQuantityTypeIdentifierInsulinDelivery',
      ],
    };

    final List<DropdownMenuItem<String>> items = [];

    groupedIdentifiers.forEach((category, identifiers) {
      // 只添加有数据的分类
      if (identifiers.isNotEmpty) {
        // 添加分类标题
        items.add(
          DropdownMenuItem<String>(
            value: '__CATEGORY_${category}__', // 使用特殊值标识分类标题
            enabled: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '── $category ──',
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        );

        // 添加该分类下的所有标识符
        for (final identifier in identifiers) {
          items.add(
            DropdownMenuItem<String>(
              value: identifier,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      HealthIconService.getIconForIdentifier(identifier),
                      size: 16,
                      color: HealthIconService.getColorForIdentifier(identifier),
                    ),
                    const SizedBox(width: 8),
                    Text(HealthIconService.getDisplayNameForIdentifier(identifier)),
                  ],
                ),
              ),
            ),
          );
        }
      }
    });

    return items;
  }

  /// 获取按分类组织的数据来源下拉菜单项
  List<DropdownMenuItem<String>> _getGroupedSourceNameItems() {
    final Map<String, List<String>> groupedSourceNames = {
      '健康应用': _availableSourceNames.where((name) => name.contains('Health')).toList(),
      '第三方应用': _availableSourceNames.where((name) => !name.contains('Health')).toList(),
    };

    final List<DropdownMenuItem<String>> items = [];

    groupedSourceNames.forEach((category, sourceNames) {
      // 只添加有数据的分类
      if (sourceNames.isNotEmpty) {
        // 添加分类标题
        items.add(
          DropdownMenuItem<String>(
            value: '__CATEGORY_${category}__', // 使用特殊值标识分类标题
            enabled: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '── $category ──',
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        );

        // 添加该分类下的所有数据来源
        for (final sourceName in sourceNames) {
          items.add(
            DropdownMenuItem<String>(
              value: sourceName,
              child: Container(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(sourceName)),
            ),
          );
        }
      }
    });

    return items;
  }
}

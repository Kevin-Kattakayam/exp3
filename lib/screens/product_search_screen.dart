import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../models/product.dart';
import '../widgets/category_filter_chip.dart';
import '../widgets/price_range_slider.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/sort_dropdown.dart';
import '../widgets/stock_filter_checkbox.dart';

/// Screen that provides interactive search, filtering, and sorting capabilities.
class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _currentSort = 'Name (A–Z)';
  bool _showInStockOnly = false;
  bool _showFiltersPanel = false;

  static const double _minPrice = 0.0;
  static const double _maxPrice = 250.0;
  RangeValues _priceRange = const RangeValues(_minPrice, _maxPrice);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
      _currentSort = 'Name (A–Z)';
      _showInStockOnly = false;
      _priceRange = const RangeValues(_minPrice, _maxPrice);
    });
  }

  List<Product> get _filteredAndSortedProducts {
    var list = ProductData.products.where((product) {
      // Search query filter (matches name or description)
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());

      // Category filter
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      // Price range filter
      final matchesPrice = product.price >= _priceRange.start &&
          product.price <= _priceRange.end;

      // In-stock filter
      final matchesStock = !_showInStockOnly || product.inStock;

      return matchesSearch && matchesCategory && matchesPrice && matchesStock;
    }).toList();

    // Sorting
    switch (_currentSort) {
      case 'Name (A–Z)':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z–A)':
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating: High to Low':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...ProductData.categories];
    final filteredList = _filteredAndSortedProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          '🔍 Product Search & Filter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showFiltersPanel ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            tooltip: 'Toggle Filter Panel',
            onPressed: () {
              setState(() {
                _showFiltersPanel = !_showFiltersPanel;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Filters',
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header / Search Area
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                ProductSearchBar(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ],
            ),
          ),

          // Collapsible filter panel
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showFiltersPanel
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  PriceRangeSlider(
                    currentRange: _priceRange,
                    min: _minPrice,
                    max: _maxPrice,
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StockFilterCheckbox(
                        showInStockOnly: _showInStockOnly,
                        onChanged: (val) {
                          setState(() {
                            _showInStockOnly = val;
                          });
                        },
                      ),
                      SortDropdown(
                        currentSort: _currentSort,
                        onChanged: (val) {
                          setState(() {
                            _currentSort = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Horizontal category chips
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return CategoryFilterChip(
                  label: cat,
                  isSelected: _selectedCategory == cat,
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Results Count / Active filters indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredList.length} items found',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                if (!_showFiltersPanel)
                  SortDropdown(
                    currentSort: _currentSort,
                    onChanged: (val) {
                      setState(() {
                        _currentSort = val;
                      });
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Products List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No products match your criteria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _resetFilters,
                          child: const Text('Reset All Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredList[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

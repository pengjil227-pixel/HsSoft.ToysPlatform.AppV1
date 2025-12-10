import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/pages/company/search.dart';
import 'package:flutter_wanhaoniu/src/shared/models/source_supplier.dart';
import 'package:go_router/go_router.dart';

import '../../pages/company/goods_detail.dart';
import '../../pages/company/home_screen.dart';
import '../../pages/company/setting.dart';
//个人信息
import '../../pages/company/setting_pages/user_info_page.dart';
//关于我们
import '../../pages/company/setting_pages/about_us_page.dart';
import '../../pages/company/category_page.dart';
import '../../pages/company/cart.dart';
import '../../pages/company/sourcefactory/factory_detail.dart';
import '../../pages/company/sourcefactory/factory_name_page.dart';
import '../../pages/company/sourcefactory/factory_list_page.dart';
import '../../pages/company/my/company_info_page.dart';
import '../../pages/company/my/account_manage_page.dart';
import '../../pages/company/my/online_service_page.dart';
import '../../pages/company/my/product_compare_page.dart';
import '../../pages/cart/cart_settings_page.dart';
import '../../pages/company/my/browse_history_page.dart';
import '../../pages/company/my/collection_page.dart';
import '../../pages/company/my/follow_factory_page.dart';
import '../../pages/company/my/sample_quote_create_page.dart';
import '../../pages/company/my/sample_quote_page.dart';
import '../../pages/company/my/sample_quote_detail_page.dart';
import '../../pages/company/my/sample_quote_state.dart';
import '../../widgets/products_view.dart';

class CompanyRoutes {
  static List<GoRoute> get routes {
    return [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: 'setting',
            name: 'setting',
            builder: (context, state) => Setting(),
            routes: [
              GoRoute(
                path: 'userInfo',
                name: 'userInfo',
                builder: (context, state) => const UserInfoPage(),
              ),
              GoRoute(
                path: 'aboutUs',
                name: 'aboutUs',
                builder: (context, state) => const AboutUsPage(),
              ),
              GoRoute(
                path: 'category',
                name: 'category',
                builder: (context, state) => const CategoryPage(),
              ),
              GoRoute(
                path: 'factoryDetail',
                name: 'factoryDetail',
                builder: (context, state) => FactoryDetailPage(
                  supplier: state.extra is SourceSupplier ? state.extra as SourceSupplier : null,
                ),
              ),
              GoRoute(
                path: 'factoryName',
                name: 'factoryName',
                builder: (context, state) {
                  final extra = state.extra;
                  SourceSupplier? supplier;
                  SupplierDetail? detail;
                  if (extra is SupplierDetail) {
                    detail = extra;
                  } else if (extra is SourceSupplier) {
                    supplier = extra;
                  } else if (extra is Map) {
                    if (extra['supplier'] is SourceSupplier) supplier = extra['supplier'] as SourceSupplier;
                    if (extra['detail'] is SupplierDetail) detail = extra['detail'] as SupplierDetail;
                  }
                  return FactoryNamePage(supplier: supplier, detail: detail);
                },
              ),
              GoRoute(
                path: 'factoryList',
                name: 'factoryList',
                builder: (context, state) => FactoryListPage(
                  type: state.extra is FactoryListType ? state.extra as FactoryListType : FactoryListType.all,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'goodsDetail/:index',
            name: 'goodsDetail',
            builder: (context, state) {
              // 从extra中获取ProductsParameters对象
              if (state.extra is ProductsParameters) {
                return GoodsDetail(
                  parameters: state.extra as ProductsParameters,
                );
              }
              // 如果没有传递extra，返回错误页面或空页面
              return Scaffold(
                appBar: AppBar(title: const Text('商品详情')),
                body: const Center(child: Text('商品信息加载失败')),
              );
            },
          ),
          GoRoute(
            path: 'cart',
            name: 'cart',
            builder: (context, state) => const CartPage(),
            routes: [
              GoRoute(
                path: 'settings',
                name: 'cartSettings',
                builder: (context, state) => const CartSettingsPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'companyInfo',
            name: 'companyInfo',
            builder: (context, state) => const CompanyInfoPage(),
          ),
          GoRoute(
            path: 'accountManage',
            name: 'accountManage',
            builder: (context, state) => const AccountManagePage(),
          ),
          GoRoute(
            path: 'onlineService',
            name: 'onlineService',
            builder: (context, state) => const OnlineServicePage(),
          ),
          GoRoute(
            path: 'productCompare',
            name: 'productCompare',
            builder: (context, state) => const ProductComparePage(),
          ),
          GoRoute(
            path: 'browseHistory',
            name: 'browseHistory',
            builder: (context, state) => const BrowseHistoryPage(),
          ),
          GoRoute(
            path: 'collection',
            name: 'collection',
            builder: (context, state) => const CollectionPage(),
          ),
          GoRoute(
            path: 'followFactory',
            name: 'followFactory',
            builder: (context, state) => const FollowFactoryPage(),
          ),
          GoRoute(
            path: 'sampleQuote',
            name: 'sampleQuote',
            builder: (context, state) {
              final SampleQuoteRecord? record =
                  state.extra is SampleQuoteRecord ? state.extra as SampleQuoteRecord : null;
              return SampleQuotePage(pendingRecord: record);
            },
            routes: [
              GoRoute(
                path: 'create',
                name: 'sampleQuoteCreate',
                builder: (context, state) {
                  final Object? extra = state.extra;
                  final List<QuoteProductInput> products =
                      extra is List<QuoteProductInput> ? extra : <QuoteProductInput>[];
                  return SampleQuoteCreatePage(selectedProducts: products);
                },
              ),
              GoRoute(
                path: 'detail',
                name: 'sampleQuoteDetail',
                builder: (context, state) {
                  final SampleQuoteRecord? record =
                      state.extra is SampleQuoteRecord ? state.extra as SampleQuoteRecord : null;
                  return SampleQuoteDetailPage(quote: record);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'search',
            name: 'search',
            pageBuilder: (_, GoRouterState state) {
              return NoTransitionPage(
                child: SearchPage(),
              );
            },
          ),
        ],
      ),
    ];
  }
}

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
import '../../pages/company/sourcefactory/factory_detail.dart';
import '../../pages/company/sourcefactory/factory_name_page.dart';
import '../../pages/company/sourcefactory/factory_list_page.dart';
import '../../pages/company/my/company_info_page.dart';
import '../../pages/company/my/account_manage_page.dart';
import '../../pages/company/my/online_service_page.dart';
import '../../pages/company/my/product_compare_page.dart';
import '../../widgets/goods_item.dart';

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
            path: 'goodsDetail',
            name: 'goodsDetail',
            builder: (context, state) {
              ProductsParameters parameters = state.extra as ProductsParameters;
              return GoodsDetail(
                parameters: parameters,
              );
            },
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
            path: 'search',
            name: 'search',
            builder: (context, state) {
              return SearchPage();
            },
          ),
        ],
      ),
    ];
  }
}

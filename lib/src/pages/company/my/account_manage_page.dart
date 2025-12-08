import 'package:flutter/material.dart';

class AccountManagePage extends StatelessWidget {
  const AccountManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        leadingWidth: 40,
        leading: const BackButton(),

        
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 34,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索账号',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE23E3E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE23E3E)),
                      ),

                  
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          width: 65, 
                          height: 27, 
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '搜索',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 65,
                        minHeight: 27,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
        
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '提示: 手机版仅做查看，若需操作请到网页版',
                  style: TextStyle(color: Color(0xFFE53935)),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFEDEDED),
                          child: Text(
                            'A$index',
                            style: const TextStyle(color: Color(0xFF666666)),
                          ),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '某某某（180 **** ****）',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),

                              Chip(
                                label: const Text(
                                  '销售',
                                  style: TextStyle(
                                    color: Color(0xFFE39B00),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  side: const BorderSide(
                                    color: Color(0xFFE39B00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

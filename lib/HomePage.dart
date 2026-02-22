import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  int selectedStoryIndex = 0;

  PageController? _pageController;

  final List<IconData> storiesIcons = [
    Icons.person,
    Icons.group,
    Icons.person_3,
    Icons.campaign,
    Icons.smart_toy,
    Icons.remove_red_eye,
    Icons.mark_chat_unread,
  ];
  final Map<int, List<Map<String, String>>> chatsByTab = {
    0: List.generate(12, (i) => {
      "name": "User ${i + 1}",
      "msg": "Salom, bu user ${i + 1}",
      "time": "${12 - i}:00",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    1: List.generate(12, (i) => {
      "name": "Group ${i + 1}",
      "msg": "Bugun meeting ${i + 1}",
      "time": "${11 - i}:15",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    2: List.generate(12, (i) => {
      "name": "Friend ${i + 1}",
      "msg": "Salom, friend ${i + 1}",
      "time": "${10 - i}:30",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    3: List.generate(12, (i) => {
      "name": "Channel ${i + 1}",
      "msg": "Yangi post ${i + 1}",
      "time": "${9 - i}:45",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    4: List.generate(12, (i) => {
      "name": "Bot ${i + 1}",
      "msg": "Update ${i + 1}",
      "time": "${8 - i}:10",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    5: List.generate(12, (i) => {
      "name": "Mixed ${i + 1}",
      "msg": "Chat ${i + 1}",
      "time": "${7 - i}:50",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),

    6: List.generate(12, (i) => {
      "name": "Unread ${i + 1}",
      "msg": "Yangi xabar ${i + 1}",
      "time": "${6 - i}:25",
      "avatar": "assets/person${(i % 5) + 1}.png",
    }),
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedStoryIndex);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => selectedStoryIndex = index);
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 50),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: const Color(0xFF181818).withOpacity(0.7),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  SizedBox(
                    width: 85,
                    height: 35,
                    child: Stack(
                      children: [
                        Positioned(right: 0, child: _buildAvatar("assets/person3.png", Colors.green)),
                        Positioned(right: 20, child: _buildAvatar("assets/person2.png", Colors.green)),
                        Positioned(right: 40, child: _buildAvatar("assets/person1.png", Colors.green)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "22 Stories",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.lock_open)),
                IconButton(icon: const FaIcon(FontAwesomeIcons.ghost, size: 20), onPressed: () {}),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: storiesIcons.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedStoryIndex == index;
                      return GestureDetector(
                        onTap: () => _onTabSelected(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                storiesIcons[index],
                                color: isSelected ? Colors.blue : Colors.white54,
                                size: 26,
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                height: 3,
                                width: 26,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: PageView.builder(
        controller: _pageController,
        itemCount: storiesIcons.length,
        onPageChanged: (index) => setState(() => selectedStoryIndex = index),
        itemBuilder: (context, index) {
          final chats = chatsByTab[index] ?? [];

          return Container(
            color: const Color(0xFF181818),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: kToolbarHeight + 110),
              itemCount: chats.length,
              itemBuilder: (context, chatIndex) {
                final chat = chats[chatIndex];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  leading: Stack(
                    children: [
                      CircleAvatar(radius: 26, backgroundImage: AssetImage(chat["avatar"]!)),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF181818), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(chat["name"]!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(chat["msg"]!, style: const TextStyle(color: Colors.grey)),
                  trailing: Text(chat["time"]!, style: const TextStyle(color: Colors.grey)),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "edit",
            mini: true,
            backgroundColor: Colors.grey.shade800,
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "camera",
            backgroundColor: Colors.blue,
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String assetPath, Color borderColor) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
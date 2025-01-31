import 'package:flutter/material.dart';
import 'package:inha_notice/utils/read_notice_manager.dart';
import 'package:inha_notice/utils/bookmark_manager.dart';
import 'package:inha_notice/constants/page_constants.dart';
import 'package:inha_notice/services/base_notice_scraper.dart';

// 공지사항 페이지의 인터페이스를 제공합니다.
abstract class BaseNoticeBoard extends StatefulWidget {
  const BaseNoticeBoard({super.key});
}

abstract class BaseNoticeBoardState<T extends BaseNoticeBoard>
    extends State<T> {
  // 오버라이딩 필요
  late BaseNoticeScraper noticeScraper;

  Future<void> loadNotices(int page);

  Map<String, dynamic> notices = {'headline': [], 'general': [], 'pages': []};
  List<Map<String, dynamic>> initialPages = [];

  // 읽은 공지사항과 북마크된 공지사항을 캐싱하여 메모리에서 관리.
  Set<String> readNotices = {};
  Set<String> bookmarkedNotices = {};

  bool isLoading = true;
  bool showHeadlines = false;
  bool showGeneral = true;
  int currentPage = PageSettings.kInitialPage;

  Future<void> initializeReadAndBookmark() async {
    final Set<String> readIds = await ReadNoticeManager.loadReadNotices();
    final Set<String> bookmarkedIds = await BookmarkManager.getAllBookmarks();
    readNotices = readIds;
    bookmarkedNotices = bookmarkedIds;
  }

  // 공지를 읽었는지 확인
  bool isNoticeRead(String noticeId) {
    return readNotices.contains(noticeId);
  }

  // 공지를 읽음으로 표시
  Future<void> markNoticeAsRead(String noticeId) async {
    readNotices.add(noticeId);
    await ReadNoticeManager.saveReadNotices(readNotices);
    setState(() {});
  }

  // 공지가 북마크되었는지 확인
  bool isNoticeBookmarked(String noticeId) {
    return bookmarkedNotices.contains(noticeId);
  }

  // 북마크 추가
  Future<void> addNoticeBookmarked(String noticeId) async {
    bookmarkedNotices.add(noticeId);
    await BookmarkManager.addBookmark(noticeId);
  }

  // 북마크 삭제
  Future<void> removeNoticeBookmarked(String noticeId) async {
    bookmarkedNotices.remove(noticeId);
    await BookmarkManager.removeBookmark(noticeId);
  }

  // 공지의 북마크 상태를 토글
  Future<void> toggleBookmark(String noticeId) async {
    if (isNoticeBookmarked(noticeId)) {
      removeNoticeBookmarked(noticeId);
    } else {
      addNoticeBookmarked(noticeId);
    }
    setState(() {});
  }

  void toggleOption(String option) {
    setState(() {
      if (option == 'headline') {
        showHeadlines = true;
        showGeneral = false;
      } else if (option == 'general') {
        showHeadlines = false;
        showGeneral = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildMain(),
          buildFooter(),
        ],
      ),
    );
  }

  Widget buildHeader();

  Widget buildMain();

  Widget buildFooter();
}

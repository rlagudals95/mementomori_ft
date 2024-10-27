import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// InAppWebViewScreen 클래스는 웹뷰를 포함하는 StatefulWidget입니다.
class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({Key? key}) : super(key: key);

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

// _InAppWebViewScreenState는 InAppWebViewScreen의 상태를 관리합니다.
class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey(); // 웹뷰의 고유 키
  Uri myUrl = Uri.parse(
      "https://coloso.co.kr/products/programming-funcoding"); // 초기 URL 설정

  late final InAppWebViewController webViewController; // 웹뷰 컨트롤러
  late final PullToRefreshController pullToRefreshController; // 당겨서 새로고침 컨트롤러

  double progress = 0; // 로딩 진행률

  @override
  void initState() {
    super.initState();

    // 당겨서 새로고침 컨트롤러 초기화
    pullToRefreshController = (kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue, // 새로고침 시 로딩 인디케이터 색상
            ),
            onRefresh: () async {
              // 플랫폼에 따라 새로고침 동작 설정
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController.reload(); // 안드로이드에서는 페이지 새로고침
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController.loadUrl(
                    urlRequest: URLRequest(
                        url: await webViewController
                            .getUrl())); // iOS 및 macOS에서는 현재 URL 다시 로드
              }
            },
          ))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: WillPopScope(
                onWillPop: () => _goBack(context), // 뒤로가기 버튼 동작 설정
                child: Column(children: <Widget>[
                  progress < 1.0
                      ? LinearProgressIndicator(
                          value: progress, color: Colors.blue) // 로딩 진행률 표시
                      : Container(),
                  Expanded(
                      child: Stack(children: [
                    InAppWebView(
                      key: webViewKey, // 웹뷰의 고유 키 설정
                      initialUrlRequest: URLRequest(
                          url: WebUri(
                              'https://velog.io/@jhkim0122/flutterinappwebview%EB%A1%9C-hybrid-app-%EB%A7%8C%EB%93%A4%EA%B8%B0')), // 초기 URL 설정
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            javaScriptCanOpenWindowsAutomatically:
                                true, // 자바스크립트로 새 창 열기 허용
                            javaScriptEnabled: true, // 자바스크립트 사용 허용
                            useOnDownloadStart: true, // 다운로드 시작 시 콜백 사용
                            useOnLoadResource: true, // 리소스 로드 시 콜백 사용
                            useShouldOverrideUrlLoading: true, // URL 로딩 시 콜백 사용
                            mediaPlaybackRequiresUserGesture:
                                true, // 미디어 재생 시 사용자 제스처 필요
                            allowFileAccessFromFileURLs:
                                true, // 파일 URL로부터 파일 접근 허용
                            allowUniversalAccessFromFileURLs:
                                true, // 파일 URL로부터의 범용 접근 허용
                            verticalScrollBarEnabled: true, // 세로 스크롤바 사용
                            userAgent:
                                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.122 Safari/537.36'), // 사용자 에이전트 설정
                        android: AndroidInAppWebViewOptions(
                            useHybridComposition: true, // 하이브리드 컴포지션 사용
                            allowContentAccess: true, // 콘텐츠 접근 허용
                            builtInZoomControls: true, // 내장 줌 컨트롤 사용
                            thirdPartyCookiesEnabled: true, // 서드파티 쿠키 허용
                            allowFileAccess: true, // 파일 접근 허용
                            supportMultipleWindows: true), // 다중 창 지원
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true, // 인라인 미디어 재생 허용
                          allowsBackForwardNavigationGestures:
                              true, // 앞뒤 탐색 제스처 허용
                        ),
                      ),
                      pullToRefreshController:
                          pullToRefreshController, // 당겨서 새로고침 컨트롤러 설정
                      onLoadStart: (InAppWebViewController controller, uri) {
                        setState(() {
                          myUrl = Uri.parse(
                              "https://coloso.co.kr/products/programming-funcoding"); // 페이지 로드 시작 시 URL 업데이트
                        });
                      },
                      onLoadStop: (InAppWebViewController controller, uri) {
                        setState(() {
                          myUrl = Uri.parse(
                              "https://coloso.co.kr/products/programming-funcoding");
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController
                              .endRefreshing(); // 로딩 완료 시 새로고침 종료
                        }
                        setState(() {
                          this.progress = progress / 100; // 로딩 진행률 업데이트
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction
                                .GRANT); // 권한 요청 시 자동 승인
                      },
                      onWebViewCreated: (InAppWebViewController controller) {
                        webViewController = controller; // 웹뷰 생성 시 컨트롤러 저장

                        controller.addJavaScriptHandler(
                            handlerName: 'myHandlerName',
                            callback: (args) {
                              // print arguments coming from the JavaScript side!
                              print(args);

                              // return data to the JavaScript side!
                              return {'bar': 'bar_value', 'baz': 'baz_value'};
                            });
                      },

                      onCreateWindow: (controller, createWindowRequest) async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child: InAppWebView(
                                  windowId: createWindowRequest
                                      .windowId, // 새 창 생성 시 windowId 설정
                                  initialOptions: InAppWebViewGroupOptions(
                                    android: AndroidInAppWebViewOptions(
                                      builtInZoomControls: true, // 내장 줌 컨트롤 사용
                                      thirdPartyCookiesEnabled:
                                          true, // 서드파티 쿠키 허용
                                    ),
                                    crossPlatform: InAppWebViewOptions(
                                        cacheEnabled: true, // 캐시 사용
                                        javaScriptEnabled: true, // 자바스크립트 사용 허용
                                        userAgent:
                                            "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36"), // 사용자 에이전트 설정
                                    ios: IOSInAppWebViewOptions(
                                      allowsInlineMediaPlayback:
                                          true, // 인라인 미디어 재생 허용
                                      allowsBackForwardNavigationGestures:
                                          true, // 앞뒤 탐색 제스처 허용
                                    ),
                                  ),
                                  onCloseWindow: (controller) async {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context); // 창 닫기 시 다이얼로그 닫기
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                        return true; // 새 창 생성 허용
                      },
                    )
                  ]))
                ]))));
  }

  // 뒤로가기 버튼 동작 정의
  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController.canGoBack()) {
      webViewController.goBack(); // 이전 페이지로 이동
      return Future.value(false); // 뒤로가기 동작 취소
    } else {
      return Future.value(true); // 뒤로가기 동작 허용
    }
  }
}

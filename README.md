# WatchFocus

![Group 304](https://github.com/bangtori/WatchFocus/assets/58802345/a9a02281-a1fb-4883-9274-3ee82afa15da)




## 📌 프로젝트 소개
> 워치와 위젯 연동을 통한 할일 관리 및 사용자 설정 뽀모도로 타이머를 통한 집중 관리 APP <br/>
> 개발 기간 : 2024.02.11 ~ (진행중) <br/>
> 개발 환경 : Swift 5.9, Xcode 14.0, iOS 17.0 이상 <br/>


언제 어디서든 직접 iOS 앱을 실행하지 않고서도 위젯이나 워치로 접근하여 작동할 수 있어 접근성 높은 관리 기능을 제공


<br/><br/>


## 📌 기능 소개
#### ✅ Todo List
- iOS, watchOS, widget 모두 연동되는 Todo List 제공 
- 잠금화면 위젯 지원
- Todo List 최대 5개 카테고리 분류 가능
- 전체 달성률 및 카테고리 별 달성률 제공
- SNS 업로드 및 커뮤니티 공유 등 다른 사람들과의 자극 공유를 위한 달성률 그래프 공유 기능 제공
####  ⏱️ Pomodoro Timer
- iOS, watchOS 별개의 타이머 제공 
- iOS 타이머의 경우 백그라운드에서 LiveActivity를 통한 실시간 타이머 현황 확인 가능 
- Dynamic Island 지원 모델의 경우 Dynamic Island 기능 또한 지원



<br/><br/>

## 📌 구현 화면
#### ✅ Todo List
<table align="center">
  <tr>
    <th><code>할일 관리</code></th>
    <th><code>할일 추가</code></th>
    <th><code>공유하기</code></th>
  </tr>
  <tr>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/489c11d9-bf98-45ba-b2d4-919537a21483" alt="할일 관리">
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/635472bf-06d6-4f14-849a-5845da128904" alt="할일 추가"></td>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/6aae809d-8a48-4bb3-b208-e393185242cf" alt="공유 하기"></td>
  </tr>
</table>

####  ⏱️ Pomodoro Timer
<table align="center">
  <tr>
    <th><code>타이머 설정</code></th>
    <th><code>뽀모도로 타이머</code></th>
    </tr>
      <tr>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/35ce6f3d-66be-4dce-b497-32911a16d887" alt="타이머 설정"></td>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/c343c464-6df2-4789-9243-d07b2c2672a5" alt="뽀모도로 타이머">
    </tr>
  <tr>
    <th><code>Live Activity</code></th>
    <th><code>Dynamic Island</code></th>
  </tr>
<tr>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/de819831-f00d-43f2-ac55-2a5665c6f20e" alt="Live Activity"></td>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/8454de76-67a7-40d0-ad48-053d4442308e" alt="Dynamic Island"></td>
  </tr>
  </table>

  #### ⌚️ Watch
  <table align="center">
  <tr>
    <th><code>할일 관리 </code></th>
    <th><code>타이머 </code></th>
  </tr>
  <tr>
      <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/699b47a7-51ba-42f0-a80f-96572a8828b8" alt="워치 할일 관리"></td>
    <td><img src="https://github.com/bangtori/WatchFocus/assets/58802345/bfa499b5-c448-4207-ac25-bd4e45109c1f" alt="타이머 워치" width="270"></td>
  </tr>
</table>

## 📌 기술 스택
<img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white"><img src="https://img.shields.io/badge/SwiftUI-0070FD?style=for-the-badge&logo=swift&logoColor=black"><img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"><img src="https://img.shields.io/badge/realm-39477F?style=for-the-badge&logo=realm&logoColor=white">

#### 기술스택
- SwiftUI
- watchOS, Widget Extension, LiveActivity
- Realm-swift
- DarkMode, DYColor
<br>
[DYColor : 다크모드 대응 라이브러리 (직접 제작)](https://github.com/bangtori/DYColor)


<br/><br/>


## 📌 Folder Convention
```
📦 WatchFocus
+-- 🗂 Config
+-- 🗂 Common
+-- 🗂 Extention 
+-- 🗂 Service
+-- 🗂 Model 
+-- 🗂 View
|    +-- 🗂 Todo
|    +-- 🗂 Timer
+-- 🗂 ViewModel

📦 WatchFocus WatchApp
+-- 🗂 Config
+-- 🗂 View
|    +-- 🗂 Todo
|    +-- 🗂 Timer
+-- 🗂 ViewModel
```

<br/><br/>




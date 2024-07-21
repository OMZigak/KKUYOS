![Frame 1000002424](https://github.com/OMZigak/iOS/assets/144984293/d5e851a7-4ecf-467f-a09a-7cb3433b996d)
![표지](https://github.com/user-attachments/assets/f1982348-39cd-45c4-bb73-3266637734be)
```
이 세상 모든 지각 꾸물이들의 정시 도착 꿈을 이뤄줄 꿈같은 서비스, 꾸물꿈 ⏰💤
34기 NOW SOPT AppJam 꾸물꿈 프로젝트입니다.
```
[꾸물꿈에 대해 더 자세히 알고 싶다면? 프로젝트 설계 및 주요 기능 소개 보기✔️](https://arrow-frog-4b9.notion.site/9c6895231a2346d0b5b9a15570f47b22?pvs=4)

</br>

![Frame 1000002423](https://github.com/OMZigak/iOS/assets/144984293/e8373f56-2bf7-4f99-ba68-a8eb94c31c9e)

|김진웅</br>[@JinUng41](https://github.com/JinUng41)|이지훈</br>[@hooni0918](https://github.com/hooni0918)|이유진</br>[@youz2me](https://github.com/youz2me)|김수연</br>[@mmaybei](https://github.com/mmaybei)|
|:---:|:---:|:---:|:---:|
|<img src = "https://github.com/user-attachments/assets/9ec0d2f4-3515-4d2c-8433-b0326a06b6ac" width ="250">|<img src = "https://github.com/user-attachments/assets/513a88e4-db78-4e11-9c42-6dda99bfe6fa" width ="250">|<img src = "https://github.com/user-attachments/assets/566a0a8c-c673-4650-b9f4-3b74d7443aa9" width ="250">|<img src = "https://github.com/user-attachments/assets/0c785026-a0c1-4e1a-bc28-fc12072b724e" width ="250">|
|`약속 추가 플로우`, `모임 상세`|`푸시 알림`, `온보딩`, `마이페이지`|`모임 추가 플로우`, `약속 상세`|`홈`, `내 모임`, `준비 정보 입력`|
</br>

![Frame 1000002428](https://github.com/OMZigak/iOS/assets/144984293/8c3ba259-6b8d-47b9-9f5d-97e8bc48ccd7)

|library|description|
|:---:|:---:|
|**FirebaseSDK**|FCM을 이용한 푸쉬 알림을 구현하기 위함|
|**KakaoSDK**|카카오 소셜 로그인 구현을 위함|
|**Lookin**|UI 구현에 있어, 뷰 계층을 보다 쉽게 파악하기 위함|
|**Moya**|추상화된 네트워크 레이어를 보다 간편하게 사용하기 위함|
|**RxCocoa**|뷰의 상태 관리를 위한 동적 프로그래밍 도입|
|**RxSwift**|뷰의 상태 관리를 위한 동적 프로그래밍 도입|
|**Snapkit**|UI 구현에 있어, 오토레이아웃을 보다 간편하게 사용하기 위함|
|**Then**|UI 구현에 있어, 클로저를 통해 인스턴스를 초기화하기 위함|
|**Kingfisher**|이미지 캐싱 처리 및 UI 성능 개선을 위함|
</br>


![Frame 1000002425](https://github.com/OMZigak/iOS/assets/144984293/7975890a-1ffc-4b51-84e8-8102c454c52e)
[꾸물아요들의 코딩컨벤션 보기✔️](https://github.com/OMZigak/iOS_Styleguide)
</br>
</br>


![Frame 1000002426](https://github.com/OMZigak/iOS/assets/144984293/fc19dbd0-5755-4a67-87c0-8ab4b1558ea2)
```
main 브랜치: 최종 제출용
suyeon 브랜치: 개발 작업용 (default 브랜치)

1. 기능 개발, 네트워크, 리팩토링, 세팅 등 작업할 내용에 대한 이슈 생성
2. suyeon 브랜치에서 이슈 브랜치 생성
3. 이슈 브랜치에서 작업
4. 작업 완료 후 PR 작성, 체크리스트를 통해 어떤 것을 해결한 이슈인지 명시
5. 코드리뷰를 통해 모든 구성원이 approve하였을 때 suyeon 브랜치로 머지
```
</br>

![Frame 1000002427](https://github.com/OMZigak/iOS/assets/144984293/89e48d23-a134-4ad1-8c9d-bf01769a2f46)
```
📁 Kkumulkkum
├── 📁 Application
│   ├── AppDelegate
│   ├── SceneDelegate
├── 📁 Source
│   ├── 🗂️ Onboarding
│   │   ├── 🗂️ Model
│   │   ├── 🗂️ ViewModel
│   │   ├── 🗂️ View
│   │   ├── 🗂️ ViewController
│   ├── 🗂️ Home
│   ├── 🗂️ My
│   ├── 🗂️ Core
│   │   ├── TabBar
│   │   ├── View
│   │   ├── Cell
├── 📁 Resource
|   ├── 🗂️ Extension
|   |   ├── UIStackView+
|   |   ├── UIView+
|   |   ├── ...
|   ├── 🗂️ Util
|   |   ├── ReuseIdentifiable
|   |   ├── Screen
|   |   ├── ...
|   ├── 🗂️ Font
|   |   ├── .ttf
|   ├── Asset.xcassets
│   ├── Info.plist
├── 📁 Network
```

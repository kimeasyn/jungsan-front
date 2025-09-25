# 정산 앱 (Jungsan Front)

여행과 게임에서 사용할 수 있는 간편한 정산 앱입니다. Flutter로 개발되어 iOS, Android, 웹에서 모두 사용할 수 있습니다.

## 🚀 주요 기능

- **여행 정산**: 여행 경비를 참가자별로 자동 계산
- **게임 정산**: 게임 결과를 금액으로 환산하여 정산
- **정산 내역**: 과거 정산 내역 조회 및 관리
- **결과 공유**: 정산 결과를 쉽게 공유
- **반응형 UI**: 모바일과 웹에서 최적화된 사용자 경험

## 📱 지원 플랫폼

- iOS (iPhone/iPad)
- Android
- Web (Chrome, Safari, Firefox)
- macOS (데스크톱)

## 🛠️ 개발 환경 설정

### 1. Flutter 설치

#### macOS에서 Flutter 설치

1. **Homebrew 설치** (아직 설치하지 않은 경우):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Flutter 설치**:
   ```bash
   brew install --cask flutter
   ```

3. **Flutter 경로 확인**:
   ```bash
   flutter --version
   ```

4. **Flutter Doctor 실행** (의존성 확인):
   ```bash
   flutter doctor
   ```

### 2. 개발 도구 설치

#### Android 개발 (Android Studio)
1. [Android Studio 다운로드](https://developer.android.com/studio)
2. Android Studio 설치 후 Flutter 플러그인 설치
3. Android SDK 설정

#### iOS 개발 (Xcode)
1. App Store에서 Xcode 설치
2. Xcode Command Line Tools 설치:
   ```bash
   sudo xcode-select --install
   ```

#### 웹 개발
- Chrome 브라우저 (권장)
- VS Code 또는 Android Studio

### 3. 프로젝트 클론 및 실행

1. **저장소 클론**:
   ```bash
   git clone https://github.com/kimeasyn/jungsan-front.git
   cd jungsan-front
   ```

2. **의존성 설치**:
   ```bash
   flutter pub get
   ```

3. **사용 가능한 디바이스 확인**:
   ```bash
   flutter devices
   ```

4. **앱 실행**:

   **웹에서 실행** (가장 간단):
   ```bash
   flutter run -d chrome
   ```

   **iOS 시뮬레이터에서 실행**:
   ```bash
   flutter run -d ios
   ```

   **Android 에뮬레이터에서 실행**:
   ```bash
   flutter run -d android
   ```

   **macOS 데스크톱에서 실행**:
   ```bash
   flutter run -d macos
   ```

## 🏗️ 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   └── settlement_models.dart
├── routes/                   # 라우팅 설정
│   └── app_router.dart
├── screens/                  # 화면들
│   ├── home_screen.dart
│   ├── travel_settlement_screen.dart
│   ├── game_settlement_screen.dart
│   ├── settlement_result_screen.dart
│   ├── history_screen.dart
│   └── profile_screen.dart
├── theme/                    # 디자인 시스템
│   ├── app_colors.dart
│   ├── app_typography.dart
│   └── app_theme.dart
└── widgets/                  # 공통 위젯
    ├── common/
    │   ├── app_button.dart
    │   ├── app_card.dart
    │   └── app_input.dart
    └── layout/
        └── app_scaffold.dart
```

## 🎨 디자인 시스템

- **컬러**: Primary (#FF6B2C), Secondary (#FFC542), Accent (#4CAF50)
- **타이포그래피**: Noto Sans KR
- **아이콘**: Lucide Icons
- **테마**: Material Design 3 기반

## 🚀 빌드 및 배포

### 웹 빌드
```bash
flutter build web
```

### iOS 빌드
```bash
flutter build ios
```

### Android 빌드
```bash
flutter build apk
```

## 🐛 문제 해결

### 일반적인 문제들

1. **Flutter Doctor 오류**:
   ```bash
   flutter doctor --android-licenses
   ```

2. **의존성 문제**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **iOS 시뮬레이터 문제**:
   ```bash
   sudo xcode-select --reset
   ```

4. **Android 에뮬레이터 문제**:
   - Android Studio에서 AVD Manager로 에뮬레이터 생성
   - 에뮬레이터가 실행 중인지 확인

### 웹에서 실행 시 주의사항

- Chrome 브라우저 사용 권장
- CORS 정책으로 인한 일부 기능 제한 가능
- 모바일 UI는 개발자 도구에서 모바일 뷰로 확인

## 📝 개발 가이드

### 코드 스타일
- Dart/Flutter 공식 스타일 가이드 준수
- `flutter analyze` 명령어로 코드 품질 확인

### 커밋 컨벤션
- `feat:` 새로운 기능
- `fix:` 버그 수정
- `docs:` 문서 수정
- `style:` 코드 스타일 변경
- `refactor:` 코드 리팩토링

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해 주세요.

---

**정산 앱**으로 더 편리한 정산을 경험해보세요! 🎯
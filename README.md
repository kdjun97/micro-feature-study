# Micro Features Architectures Test

- CMC 동아리에서 사용할 MicroFeature Architecture를 미리 검증하기 위한 테스트 프로젝트
- Tuist 기반으로 모듈과 의존성을 구성
- 실제 운영 상황을 가정해 GitHub Actions + Fastlane 기반 iOS CI/CD까지 함께 구현

## CI/CD

- Git tag prefix를 기준으로 배포 파이프라인 실행
- GitHub Actions가 태그 push를 감지
- 태그 prefix를 기반으로 scheme, environment, distribution type 결정
- Fastlane `ios cicd` lane에서 앱 빌드 및 배포 수행

### 구성 의도

- 기능 단위 빌드 및 배포 실험
- MicroFeature Architecture에 맞는 feature demo 앱 개별 배포
- 동아리 프로젝트와 실무 대형 iOS 프로젝트의 기능별 QA 상황 고려
- `dev`, `prod`, `demo`, `design` 태그 prefix 기반 배포 대상 구분

### 배포 방식

| Tag prefix | Scheme | Environment | Distribution |
| --- | --- | --- | --- |
| `dev/*` | `MicroFeatureStudy-DEV` | `DEV` | TestFlight |
| `prod/*` | `MicroFeatureStudy` | `PROD` | TestFlight |
| `demo/{DemoScheme}/*` | `{DemoScheme}` | `DEV` | Firebase App Distribution |
| `design/*` | `DesignSystemDemo` | `DEV` | Firebase App Distribution |

- `dev`, `prod` 앱은 App Store Connect에 업로드 후 TestFlight로 배포
- 각 feature demo 앱은 Firebase App Distribution으로 배포
- DesignSystem demo 앱도 Firebase App Distribution으로 배포

### Tag 규칙

- 배포 태그 형식

```bash
dev/{version}-{timestamp}
prod/{version}-{timestamp}
demo/{DemoScheme}/{version}-{timestamp}
design/{version}-{timestamp}
```

- 태그 예시

```bash
dev/1.0.0-202605281230
prod/1.0.0-202605281230
demo/SignInDemo/1.0.0-202605281230
demo/DashboardDemo/1.0.0-202605281230
design/1.0.0-202605281230
```

- `version`은 `1.0.0` 형식 사용
- `timestamp`는 10자리 숫자 형식 사용
- `DesignSystemDemo`는 `demo/DesignSystemDemo/*`가 아닌 `design/*` prefix 사용

### Workflow 흐름

- 배포 태그 push 감지
- 태그 검증 및 CI/CD 환경 결정
- XCConfig, Firebase, Tuist, Ruby 환경 준비
- Fastlane `ios cicd` lane 실행
- 배포 대상에 따라 TestFlight 또는 Firebase App Distribution 업로드

### Fastlane 배포 처리

- `appstore`: `upload_to_testflight`로 TestFlight 업로드
- `firebase`: `firebase_app_distribution`으로 Firebase App Distribution 배포

### 알림

- CI/CD 시작, 실패, 성공 상태를 Discord webhook으로 전송
- 실패 시 실패한 step과 reason을 Discord로 전송

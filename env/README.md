# 환경변수 설정 가이드

이 디렉토리는 애플리케이션의 환경변수 설정 파일들을 포함합니다.

## 📁 파일 구조

```
env/
├── .env.example          # 환경변수 템플릿 (Git에 포함)
├── .env.development      # 개발 환경 설정 (Git에 포함)
├── .env.production       # 프로덕션 환경 설정 (Git에 포함)
├── .env.test            # 테스트 환경 설정 (Git에 포함)
└── README.md            # 이 파일
```

## 🔒 보안 주의사항

- **실제 환경변수 파일들은 Git에 포함되지 않습니다**
- `.env` 파일은 로컬에서만 사용하고 절대 커밋하지 마세요
- 프로덕션 환경에서는 환경변수를 서버 설정에서 직접 관리하세요

## 🚀 사용 방법

### 1. 개발 환경 설정

```bash
# .env.example을 복사하여 .env 파일 생성
cp env/.env.example .env

# 또는 개발 환경용 설정 복사
cp env/.env.development .env
```

### 2. 환경별 설정

- **개발**: `env/.env.development` 사용
- **테스트**: `env/.env.test` 사용  
- **프로덕션**: `env/.env.production` 사용

### 3. 환경변수 값 수정

`.env` 파일을 열어서 실제 값으로 수정하세요:

```bash
# 데이터베이스 설정
DB_HOST=localhost
DB_PORT=5432
DB_NAME=jungsan_db
DB_USERNAME=your_username
DB_PASSWORD=your_secure_password

# JWT 시크릿 (반드시 변경하세요!)
JWT_SECRET=your_very_long_and_secure_jwt_secret_key_here
```

## 📋 필수 설정 항목

### 데이터베이스
- `DB_HOST`: 데이터베이스 호스트
- `DB_PORT`: 데이터베이스 포트
- `DB_NAME`: 데이터베이스 이름
- `DB_USERNAME`: 데이터베이스 사용자명
- `DB_PASSWORD`: 데이터베이스 비밀번호

### JWT 인증
- `JWT_SECRET`: JWT 서명용 시크릿 키 (최소 32자 이상)
- `JWT_EXPIRATION`: JWT 만료 시간 (밀리초)

### 서버 설정
- `SERVER_PORT`: 서버 포트
- `SERVER_HOST`: 서버 호스트

### CORS 설정
- `CORS_ALLOWED_ORIGINS`: 허용된 오리진 (쉼표로 구분)

## ⚠️ 주의사항

1. **JWT_SECRET은 반드시 강력한 랜덤 문자열로 설정하세요**
2. **프로덕션 환경에서는 DB_PASSWORD를 안전하게 관리하세요**
3. **CORS_ALLOWED_ORIGINS는 실제 도메인으로 설정하세요**
4. **환경변수 파일은 절대 Git에 커밋하지 마세요**

## 🔧 환경변수 검증

애플리케이션 시작 시 필수 환경변수가 설정되었는지 확인하는 기능을 구현하는 것을 권장합니다.

```dart
// Flutter에서 환경변수 검증 예시
void validateEnvironment() {
  const requiredVars = [
    'API_BASE_URL',
    'JWT_SECRET',
  ];
  
  for (final varName in requiredVars) {
    if (Platform.environment[varName] == null) {
      throw Exception('필수 환경변수 $varName이 설정되지 않았습니다.');
    }
  }
}
```

# 🍼 Mi Primera Comida

App de recetas para alimentación complementaria de bebés. Sugiere recetas
personalizadas (edad del bebé + ingredientes disponibles) a partir de 5 libros
de recetas en PDF, usando **Gemini** (con rotación de claves) y **DeepSeek**
como fallback.

- **Stack:** Flutter · Clean Architecture · BLoC/Cubit + Freezed · get_it · Hive
- **IA:** Google Gemini (`gemini-2.5-flash`) + DeepSeek
- **Backend:** Firebase (Auth + Hosting)
- **App ID:** `pro.devpaul.my_first_food`
- **Web live:** https://my-first-feeding.web.app

---

## 1. Requisitos

- Flutter SDK (stable) · `flutter doctor` sin errores
- Firebase CLI (`firebase --version` ≥ 13)
- 1–5 claves de Gemini ([aistudio.google.com/apikey](https://aistudio.google.com/apikey))
- (Opcional) clave DeepSeek ([platform.deepseek.com](https://platform.deepseek.com))

## 2. Configuración de claves

Las claves se inyectan en **tiempo de compilación** vía `--dart-define`
(`AppConfig` usa `String.fromEnvironment`). NO se usa `flutter_dotenv`.

```bash
cp example.env .env   # rellena tus valores reales (.env está gitignored)
```

`.env`:

```env
GEMINI_API_KEY_1=...
GEMINI_API_KEY_2=...
GEMINI_API_KEY_3=...
GEMINI_API_KEY_4=...
GEMINI_API_KEY_5=...
DEEPSEEK_API_KEY=...
APP_ENV=development
```

## 3. Desarrollo local

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # genera *.freezed/*.g
flutter run --dart-define-from-file=.env
```

> `--dart-define-from-file=.env` parsea las líneas `KEY=VALUE` y sirve tanto
> para `run` como para `build`.

---

## 4. Desplegar en Web (Firebase Hosting)

```bash
# 1. Compilar (claves inyectadas desde .env)
flutter build web --release --dart-define-from-file=.env

# 2. Desplegar (hosting.public = build/web en firebase.json)
firebase deploy --only hosting
```

URL resultante: **https://my-first-feeding.web.app**

> ⚠️ **Seguridad web:** en Flutter web cualquier clave queda embebida en el
> bundle JS y es accesible desde el cliente. **Restringe** las claves de Gemini
> por *HTTP referrer* a `my-first-feeding.web.app` en
> Google Cloud Console → APIs & Services → Credentials.

---

## 5. Compilar para Android

### 5.1 Debug / prueba rápida

```bash
flutter run --dart-define-from-file=.env            # dispositivo conectado
flutter build apk --debug --dart-define-from-file=.env
```

### 5.2 Release firmado (Play Store / distribución)

**a) Crear keystore** (una sola vez, guárdalo fuera del repo):

```bash
keytool -genkey -v -keystore ~/my-first-food.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**b) `android/key.properties`** (gitignored — NO commitear):

```properties
storePassword=<tu_password>
keyPassword=<tu_password>
keyAlias=upload
storeFile=/home/devpaul/my-first-food.jks
```

**c) Conectar la firma en `android/app/build.gradle.kts`:**

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) load(FileInputStream(f))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

**d) Compilar:**

```bash
# AAB para Play Store (recomendado)
flutter build appbundle --release --dart-define-from-file=.env
# → build/app/outputs/bundle/release/app-release.aab

# APK directo (sideload)
flutter build apk --release --dart-define-from-file=.env
# → build/app/outputs/flutter-apk/app-release.apk
```

> En Android las claves también se embeben en el binario. Para producción real,
> considera mover las llamadas IA a un backend (Cloud Functions) y no enviar
> claves al cliente.

---

## 6. Estructura (Clean Architecture)

```
lib/
├── core/            config, DI, errores
├── domain/          entities, repositories (interfaces), usecases
├── application/     blocs/cubits + states
├── infrastructure/  repos impl, datasources (Gemini/DeepSeek, Hive)
└── presentation/    screens, widgets, theme
```

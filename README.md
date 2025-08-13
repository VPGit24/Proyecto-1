# agent-ecommerce-app

A simple e-commerce assistant with a FastAPI backend and a Next.js frontend.

This project supports **Python&nbsp;3.10**.

## Backend setup

1. (Optional) create and activate a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install Python dependencies (including the dev packages used for tests):

```bash
pip install -r requirements.txt -r requirements-dev.txt
```
Run this command again if you installed the project earlier so any new
packages—such as `geopy` for the location feature—are installed. Installing the
dev requirements is necessary to run the test suite.

Alternatively you can run the helper script to create the virtual environment and install everything in one step:

```bash
./setup_env.sh
```


3. Copy the example environment file and add your credentials:

```bash
cp .env.example .env
# edit .env and set GROQ_API_KEY, SERP_API_KEY, and TAVILY_API_KEY plus your Twilio credentials
# also add SUPABASE_URL and SUPABASE_KEY
# finally add FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL and FIREBASE_PRIVATE_KEY
```

To obtain these Firebase values, open the Firebase console and create a new service
account under **Project settings → Service accounts**. Download the JSON key file
and copy the `project_id`, `client_email` and `private_key` fields into your `.env`
file. Escape newlines in the private key or set `GOOGLE_APPLICATION_CREDENTIALS`
to the path of the JSON file instead.

The `/agent` endpoint depends on these API keys. If any key is missing, calls to
the language model or search services will raise a `RuntimeError` which surfaces
as an error in the frontend.

4. Start the API server and load the variables from the `.env` file:

```bash
uvicorn backend.main:app --reload --env-file .env
```

The backend will be available at `http://localhost:8000`.
If `GROQ_API_KEY` is not set, calls to the Groq API will raise a `RuntimeError`.

### Speech endpoint

The `/speech` route accepts an audio file and returns JSON containing the
transcribed text and a data URL with spoken audio. If you want the audio
translated to English before it is spoken, pass `translate=true` as a query
parameter. The JSON fields are:

* `transcribed_text` – the text produced by Whisper
* `audio_content_url` – a `data:` URL with the MP3 audio

```bash
curl -F "file=@audio.wav" "http://localhost:8000/speech?translate=true"
```

### Notify endpoint

The `/notify` route sends an SMS using your Twilio credentials. Provide a JSON
payload with `to` and `message` fields.

```bash
curl -X POST http://localhost:8000/notify \
  -H "Content-Type: application/json" \
  -d '{"to": "+1234567890", "message": "Hello"}'
```

### Recommendations endpoint

The `/recommendations` route saves a text recommendation for the current user in your Supabase database. Send a JSON payload with `email`, `text`, and optionally `city` and `date` fields. If `date` is omitted the server will store the current time. Both `SUPABASE_URL` and `SUPABASE_KEY` must be configured.

To remove a saved recommendation, send a `DELETE` request to `/recommendations/{id}` with a JSON body containing the `email` of the owner. The server verifies the recommendation belongs to that user before deleting it and returns `{"status": "deleted"}`.

### City search endpoint

`/city_search` accepts a JSON object with a `query` field and returns up to five
matching cities. Each result includes `city`, `region` and `country`. If no
matches are found the route responds with HTTP&nbsp;404.

```bash
curl -X POST http://localhost:8000/city_search \
  -H "Content-Type: application/json" \
  -d '{"query": "Buenos"}'
```

## Frontend setup

Ensure that **Node.js 20 or later** is installed (run `node --version` to check). The frontend was tested with Node.js 20.

1. Install Node dependencies inside the `frontend` folder:

```bash
cd frontend
npm install
```
Run `npm install` again if you set up the project before this update so new
packages such as `leaflet` and `react-leaflet` are installed.

2. The frontend reads `NEXT_PUBLIC_API_URL` to know where the API is running. Create a `.env.local` file (you can copy `frontend/.env.local.example`) and set these variables. At minimum set `NEXT_PUBLIC_API_URL` to the URL of your backend (defaults to `http://localhost:8000`). Example:

```bash
# .env.local
NEXT_PUBLIC_API_URL=http://localhost:8000
# SUPABASE_URL and SUPABASE_KEY are also required
```

### Login with Google

Authentication uses [NextAuth](https://next-auth.js.org/). Copy
`frontend/.env.local.example` to `frontend/.env.local` and add your Google
OAuth credentials. Signing in is optional: you can still navigate the site
anonymously, but personalized data such as future recommendations will only be
stored when a session is present.

3. Run the development server:

```bash
npm run dev
```

The frontend will be running on `http://localhost:3000`.

The `output: export` configuration is only enabled when running `npm run export`
(for example during the Android build), so development mode works normally.

### Topic selection home

Opening the site now shows a welcome screen where you enter your name,
choose a language and city, and then pick a topic such as **Tour**, **Eat** or
**Cultural Activity**. Selecting a topic sends the first prompt and unlocks the
chat interface so you can continue the conversation. Your selections are saved
to the browser's local storage so the form is pre-filled when you return.

If you sign in with Google, the app reads your browser locale—or your Google
profile locale if available—and uses your current geolocation to guess the
city. These values pre-fill the form so you skip directly to topic selection.
Logging out brings you back to the language and city screen.

Your name, language and city are stored in `localStorage` so you don't need to
enter them again on subsequent visits. Click **Restart conversation** next to
**Reset conversation** if you want to begin a new chat while keeping these
settings.

### Using result buttons

When the assistant replies with suggested results, each option appears as a
button. Selecting a button now opens a small menu with **Links** and
**Recomendar actividad** actions. No new prompt is sent and the conversation
ends when these buttons are shown.

If the LLM response itself contains an enumerated or comma-separated list,
these items are extracted into a `choices` field and shown as buttons as well.

### Conversation controls

The chat area includes **Reset conversation** and **Restart conversation** buttons.
Reset clears only the messages, keeping your saved name, language and city. Restart
also wipes this information from local storage so you can start again with new
details. If you ever need to remove all stored data manually, open your browser's
developer tools and clear the site's local storage or run `localStorage.clear()`
from the console.

### Color settings

The project includes a `ColorConfigurator` component with a theme menu. The home
page no longer displays the **Color Settings** button to keep the interface
clean, but you can still mount this component elsewhere if you want to offer
theme controls. Available themes are `default`, `red`, `green`, `purple` and
`dark`. The menu also lets you set a custom background image:

1. Type a URL in **Background image URL** and press **Apply URL**.
2. Or choose a file with the image picker to upload a local picture.
3. Local files should be stored under `frontend/public` and referenced from the
   app as `/my-image.jpg`.

Example: setting `/beach.jpg` will load the image saved at
`frontend/public/beach.jpg`.

## AdMob configuration

Ads are displayed on both the web and Android versions using Google AdSense and AdMob. Set these variables in your `.env` file:

```bash
NEXT_PUBLIC_ADSENSE_CLIENT=your-adsense-client-id
NEXT_PUBLIC_ADSENSE_SLOT=your-adsense-slot
NEXT_PUBLIC_ADMOB_BANNER_ID=ca-app-pub-3940256099942544/6300978111
ADMOB_APP_ID=your-admob-app-id
```

Install the plugin and sync the native project:

```bash
npm install @capacitor-community/admob
npx cap sync android
```

For Android, set `<string name="admob_app_id">$ADMOB_APP_ID</string>` in
`android/app/src/main/res/values/strings.xml` and add the corresponding
`<meta-data>` entry inside `AndroidManifest.xml` as described in the plugin's
documentation.


## Building an Android APK

1. Install Capacitor dependencies inside the `frontend` folder:

   ```bash
   npm install --save @capacitor/core @capacitor/android
   npm install --save-dev @capacitor/cli
   npx cap init agent-ecommerce-app com.example.agentecommerce --web-dir=out
   ```

2. Build the project and copy the output for Android:

   ```bash
   npm run build:android
   ```

This command calls `npm run export`, which sets `NEXT_EXPORT=1` so the build
uses the `output: export` configuration.

3. Open the Android project in Android Studio:

   ```bash
   npx cap open android
   ```

4. Compile the APK from Android Studio.

## Running tests
Before running any tests, install the Python development requirements and the
frontend dependencies. The backend tests rely on packages from both
`requirements.txt` and `requirements-dev.txt`, and the frontend tests need the
Node modules installed with `npm install` inside `frontend`. Make sure these are
installed (see the setup sections above) or run:

```bash
./setup_env.sh
```


Run the backend test suite with `pytest` from the project root:

```bash
pytest
```

Frontend tests are located inside the `frontend` folder and can be executed with:

```bash
cd frontend
npm test
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

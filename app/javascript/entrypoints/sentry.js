import * as Sentry from "@sentry/browser";

Sentry.init({
  dsn: document.querySelector('meta[name="sentry-dsn"]').content,
  environment: document.querySelector('meta[name="environment"]').content,
  release: document.querySelector('meta[name="release"]').content,

  integrations: [
    new Sentry.BrowserTracing(),
    new Sentry.Replay(),
  ],

  tracesSampleRate: 1.0,
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
});

import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import legacy from '@vitejs/plugin-legacy'
import viteCompression from 'vite-plugin-compression'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(['config/routes.rb', 'app/views/**/*', 'app/components/**/*'], { delay: 500 }),
    StimulusHMR(),
    legacy(),
    viteCompression({ algorithm: 'gzip', ext: '.gz' }),
    viteCompression({ algorithm: 'brotliCompress', ext: '.br' })
  ],
  build: {
    target: "es2017",
    minify: "terser"
  }
})

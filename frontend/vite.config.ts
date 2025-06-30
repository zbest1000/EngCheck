import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vitest/config';

export default defineConfig({
	plugins: [sveltekit()],
	
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}'],
		environment: 'jsdom',
		globals: true,
		setupFiles: ['./src/setupTests.ts']
	},
	
	server: {
		host: '0.0.0.0',
		port: 3000,
		strictPort: true,
		hmr: {
			port: 3001
		}
	},
	
	preview: {
		host: '0.0.0.0',
		port: 4173,
		strictPort: true
	},
	
	optimizeDeps: {
		include: [
			'socket.io-client',
			'chart.js',
			'date-fns',
			'fuse.js',
			'marked',
			'dompurify'
		]
	},
	
	build: {
		target: 'esnext',
		sourcemap: true,
		rollupOptions: {
			output: {
				manualChunks: {
					vendor: ['svelte', '@sveltejs/kit'],
					ui: ['bits-ui', 'lucide-svelte'],
					charts: ['chart.js', 'chartjs-adapter-date-fns'],
					utils: ['date-fns', 'fuse.js', 'marked', 'dompurify']
				}
			}
		}
	},
	
	css: {
		postcss: './postcss.config.js'
	}
});
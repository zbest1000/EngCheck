import adapter from '@sveltejs/adapter-auto';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://kit.svelte.dev/docs/integrations#preprocessors
	// for more information about preprocessors
	preprocess: vitePreprocess(),

	kit: {
		// adapter-auto only supports some environments, see https://kit.svelte.dev/docs/adapter-auto for a list.
		// If your environment is not supported or you settled on a specific environment, switch out the adapter.
		// See https://kit.svelte.dev/docs/adapters for more information about adapters.
		adapter: adapter(),
		
		alias: {
			'$lib': './src/lib',
			'$components': './src/lib/components',
			'$stores': './src/lib/stores',
			'$utils': './src/lib/utils',
			'$types': './src/lib/types',
			'$api': './src/lib/api'
		},
		
		// CSP Configuration
		csp: {
			mode: 'auto',
			directives: {
				'script-src': ['self', 'unsafe-inline'],
				'style-src': ['self', 'unsafe-inline'],
				'img-src': ['self', 'data:', 'https:'],
				'font-src': ['self'],
				'connect-src': ['self', 'ws:', 'wss:']
			}
		},
		
		// Service Worker
		serviceWorker: {
			register: false
		},
		
		// Environment Variables
		env: {
			publicPrefix: 'PUBLIC_',
			privatePrefix: 'PRIVATE_'
		}
	}
};

export default config;
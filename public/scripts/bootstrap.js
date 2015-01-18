requirejs.config({
	baseUrl: 'scripts/library',
	paths: {
		app: '../app'
	}
});

requirejs(['app/main']);

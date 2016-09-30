require.config({
	baseUrl: '/scripts',
	paths: {
		jquery: 'library/jquery',
		backbone: 'library/backbone',
		underscore: 'library/underscore',
		mustache: 'library/mustache',
		text: 'library/text',
        jcrop: 'library/jcrop/jquery.Jcrop'
	}
});

requirejs(['app/main']);

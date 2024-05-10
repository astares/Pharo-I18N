"
Application for viewing the translations

You can find it in World Menu > Browse > I18N Translations
"
Class {
	#name : #I18NTranslationViewerApplication,
	#superclass : #SpApplication,
	#category : #'I18N-Tools-Translations'
}

{ #category : #'world menu' }
I18NTranslationViewerApplication class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'I18N Translations')
				action: [self open];
				parent: #Searching;
				help: 'Your translations with I18N-Pharo';
				order: 10;
				iconName: #scriptManagerIcon
]

{ #category : #'instance creation' }
I18NTranslationViewerApplication class >> open [ 
	<script>
	^self new run
]

{ #category : #running }
I18NTranslationViewerApplication >> start [
	| window |
	window := (self newPresenter: I18NTranslationViewerPresenter) open.
]

"
It is a presenter for the class I18NTranslationViewerApplication.
"
Class {
	#name : #I18NTranslationViewerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'translations'
	],
	#category : #'I18N-Tools-Translations'
}

{ #category : #accessing }
I18NTranslationViewerPresenter >> allTranslationKeys [
	"Get all the unique keys from I18NTranslators"
	| allKeys |
	allKeys := Set new.
	I18NTranslator translators valuesDo: [ :translator |
		allKeys addAll: translator translationMap keys ].
	^ allKeys asSortedCollection
]

{ #category : #layout }
I18NTranslationViewerPresenter >> defaultLayout [ 
    ^ SpBoxLayout newVertical
        add: translations;
        yourself

]

{ #category : #initialization }
I18NTranslationViewerPresenter >> initializePresenters [ 
    "Initialize and configure widgets here"
    translations := self newTree.
    self initializeTranslations.


]

{ #category : #'private - initialization' }
I18NTranslationViewerPresenter >> initializeTranslations [

	translations := self instantiate: SpTreeTablePresenter.
	translations beResizable.

	"Add a column for the translation keys"
	translations addColumn: (SpStringTableColumn new
			 title: 'Key';
			 evaluated: [ :node | node asString ];
			 yourself).

	"Add a column for each language with translations"
	I18NTranslator translators valuesDo: [ :translator |
		translations addColumn: (SpStringTableColumn new
				 title: translator getLanguage;
				 evaluated: [ :node |
					 (I18NTranslator forLanguage: translator getLanguage)
						 translationFor: node ];
				 yourself) ].
	translations roots: self allTranslationKeys
]

{ #category : #TOREMOVE }
I18NTranslationViewerPresenter >> title [
    ^ 'Translations'
]

{ #category : #accessing }
I18NTranslationViewerPresenter >> translations [
	^ translations
]

{ #category : #accessing }
I18NTranslationViewerPresenter >> translations: anObject [
	translations := anObject
]

{ #category : #'private - initialization' }
I18NTranslationViewerPresenter >> translator [
	^ I18NTranslator
]

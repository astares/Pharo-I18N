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
                             evaluated: [:node | node asString];
                             yourself).

    "Add a column for each language with translations"
    self translator translators do: [:translator |
        translations addColumn: (SpStringTableColumn new
                                 title: translator getLanguage;
                                 evaluated: [:node | 
                                     (self translator forLanguage: translator getLanguage) translationFor: node];
                                 yourself)
    ].

    "Setup roots and potentially children if hierarchical data is involved"
    translations roots: self translator defaultTranslator translationKeys sorted.
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

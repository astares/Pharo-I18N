"
A viewer for all the translations
"
Class {
	#name : #I18NTranslationViewer,
	#superclass : #ComposableModel,
	#instVars : [
		'translations'
	],
	#category : #'I18N-Tools-Translations'
}

{ #category : #spec }
I18NTranslationViewer class >> defaultSpec [
    <spec: #default>
    
    ^ SpecLayout composed
        add: #translations;
        yourself
]

{ #category : #'world menu' }
I18NTranslationViewer class >> menuCommandOn: aBuilder [
	<worldMenu>
	
	(aBuilder item: #'I18N Translations')
		action: [ self open  ]; 
		icon: Smalltalk ui icons scriptManagerIcon;
		order: 5.
		
	aBuilder withSeparatorAfter
]

{ #category : #'instance creation' }
I18NTranslationViewer class >> open [

	^(self new)
		openWithSpec
]

{ #category : #initialization }
I18NTranslationViewer >> initialize [
	super initialize.
	self translator 
			reset;
			initialize
]

{ #category : #'private initializations' }
I18NTranslationViewer >> initializeTranslations [
	| leadColumn columns |
	translations roots: self translator defaultTranslator translationKeys sorted.
	leadColumn := TreeColumnModel new
		displayBlock: [ :node | node content asString ];
		headerLabel: 'Key'.
	columns := OrderedCollection with: leadColumn.	"Dynamically add more columens depending on translators"
	self translator translators values
		do: [ :translator | 
			| column |
			column := TreeColumnModel new
				displayBlock: [ :node | (self translator forLanguage: translator getLanguage) translationFor: node content ];
				headerLabel: translator getLanguage.
			columns add: column ].
	translations columns: columns.
	translations
		rootNodeHolder: [ :item | 
			TreeNodeModel new
				content: item asString;
				icon: Smalltalk ui icons scriptManagerIcon ]
]

{ #category : #'private initializations' }
I18NTranslationViewer >> initializeWidgets [

	translations := self instantiate: TreeModel.

	self initializeTranslations
]

{ #category : #accessing }
I18NTranslationViewer >> title [

    ^ 'Translations'
]

{ #category : #accessing }
I18NTranslationViewer >> translations [
	^ translations
]

{ #category : #accessing }
I18NTranslationViewer >> translations: anObject [
	translations := anObject
]

{ #category : #'private initializations' }
I18NTranslationViewer >> translator [
	^ I8NTranslator
]

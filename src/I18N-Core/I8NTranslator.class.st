"
A Translator
"
Class {
	#name : #I8NTranslator,
	#superclass : #Object,
	#instVars : [
		'language',
		'translationMap'
	],
	#classVars : [
		'Translators'
	],
	#category : #'I18N-Core-Translations'
}

{ #category : #accessing }
I8NTranslator class >> addTranslator: aTranslator [

	self translators at: aTranslator getLanguage asSymbol put: aTranslator
]

{ #category : #defaults }
I8NTranslator class >> defaultTranslator [

	^self forLanguage: 'EN'
]

{ #category : #accessing }
I8NTranslator class >> forLanguage: aLanguage [

	^self translators 
			at: aLanguage asSymbol
			ifAbsentPut: (self newForLanguage: aLanguage)
]

{ #category : #initialization }
I8NTranslator class >> initialize [

	self reset.
	 
]

{ #category : #accessing }
I8NTranslator class >> languages [

	^self translators values collect: [:each |  each getLanguage ]
]

{ #category : #'instance creation' }
I8NTranslator class >> newForLanguage: aLanguage [

	^(self new)
		language: aLanguage;
		yourself
]

{ #category : #initialization }
I8NTranslator class >> reset [

	Translators := nil
]

{ #category : #accessing }
I8NTranslator class >> translators [

	Translators ifNil: [ Translators := Dictionary new ].
	^Translators
]

{ #category : #'message handling' }
I8NTranslator >> doesNotUnderstand: aMessage [
	|translation|
	translation := (self translationFor:  aMessage selector).
	translation ifNil: [ ^super doesNotUnderstand: aMessage ].
	^aMessage hasArguments 
		ifTrue: [ translation format: aMessage arguments ]
		ifFalse: [ translation ]
	
	
]

{ #category : #accessing }
I8NTranslator >> getLanguage [
	"use #getLanguage instead of #language since this is a translation symbol"
	
	^language
]

{ #category : #accessing }
I8NTranslator >> language: aLanguage [

	language := aLanguage
]

{ #category : #printing }
I8NTranslator >> printOn: aStream [

	aStream nextPutAll: 'Translator for: '.
	language printOn: aStream	

]

{ #category : #accessing }
I8NTranslator >> translationFor: aSymbol [ 

	^self translationMap at: aSymbol ifAbsent: nil
]

{ #category : #accessing }
I8NTranslator >> translationKeys [

	^self translationMap keys
]

{ #category : #accessing }
I8NTranslator >> translationMap [

	translationMap ifNil: [ translationMap := Dictionary new ].
	^translationMap
]

{ #category : #accessing }
I8NTranslator >> translationMap: aMap [

	translationMap := aMap
]

{ #category : #accessing }
I8NTranslator >> translations [

	^self translationMap values
]

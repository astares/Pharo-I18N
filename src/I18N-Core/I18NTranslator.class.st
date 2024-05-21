"
A Translator
"
Class {
	#name : 'I18NTranslator',
	#superclass : 'Object',
	#instVars : [
		'language',
		'translationMap'
	],
	#classVars : [
		'Translators'
	],
	#category : 'I18N-Core-Translations',
	#package : 'I18N-Core',
	#tag : 'Translations'
}

{ #category : 'accessing' }
I18NTranslator class >> addTranslator: aTranslator [

	self translators
		at: aTranslator getLanguage asSymbol
		put: aTranslator
]

{ #category : 'defaults' }
I18NTranslator class >> defaultTranslator [

	^ self forLanguage: 'EN'
]

{ #category : 'accessing' }
I18NTranslator class >> forLanguage: aLanguage [

	^ self translators
		  at: aLanguage asSymbol
		  ifAbsentPut: (self newForLanguage: aLanguage)
]

{ #category : 'class initialization' }
I18NTranslator class >> initialize [

	self reset
]

{ #category : 'accessing' }
I18NTranslator class >> languages [

	^ self translators values collect: [ :each | each getLanguage ]
]

{ #category : 'instance creation' }
I18NTranslator class >> newForLanguage: aLanguage [

	^ self new
		  language: aLanguage;
		  yourself
]

{ #category : 'class initialization' }
I18NTranslator class >> reset [
	<script>

	Translators := nil
]

{ #category : 'accessing' }
I18NTranslator class >> translators [
	<sampleInstance>

	Translators ifNil: [ Translators := Dictionary new ].
	^Translators
]

{ #category : 'reflective operations' }
I18NTranslator >> doesNotUnderstand: aMessage [

	| translation |
	translation := self translationFor: aMessage selector.
	translation ifNil: [ ^ super doesNotUnderstand: aMessage ].
	^ aMessage hasArguments
		  ifTrue: [ translation format: aMessage arguments ]
		  ifFalse: [ translation ]
]

{ #category : 'accessing' }
I18NTranslator >> getLanguage [
	"use #getLanguage instead of #language since this is a translation symbol"

	^ language
]

{ #category : 'accessing' }
I18NTranslator >> language: aLanguage [

	language := aLanguage
]

{ #category : 'printing' }
I18NTranslator >> printOn: aStream [

	aStream nextPutAll: 'Translator for: '.
	language printOn: aStream
]

{ #category : 'accessing' }
I18NTranslator >> translationFor: aSymbol [

	^ self translationMap at: aSymbol ifAbsent: nil
]

{ #category : 'accessing' }
I18NTranslator >> translationKeys [

	^ self translationMap keys
]

{ #category : 'accessing' }
I18NTranslator >> translationMap [

	translationMap ifNil: [ translationMap := Dictionary new ].
	^ translationMap
]

{ #category : 'accessing' }
I18NTranslator >> translationMap: aMap [

	translationMap := aMap
]

{ #category : 'accessing' }
I18NTranslator >> translations [

	^ self translationMap values
]

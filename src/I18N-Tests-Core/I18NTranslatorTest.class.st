"
Unit test for I18NTranslator
"
Class {
	#name : 'I18NTranslatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'instance'
	],
	#category : 'I18N-Tests-Core-Translations',
	#package : 'I18N-Tests-Core',
	#tag : 'Translations'
}

{ #category : 'accessing' }
I18NTranslatorTest >> defaultTestClass [

	^ I18NTranslator
]

{ #category : 'initialization' }
I18NTranslatorTest >> initTestInstance [

	instance := self defaultTestClass newForLanguage: 'DE'.
	instance translationMap at: #welcome put: 'Willkommen'
]

{ #category : 'running' }
I18NTranslatorTest >> setUp [
	"Set up before running the test"

	super setUp.
	self initTestInstance
]

{ #category : 'running' }
I18NTranslatorTest >> tearDown [
	"Tear down after running a test"

	instance := nil.
	super tearDown
]

{ #category : 'tests' }
I18NTranslatorTest >> testDefaultTranslatorIsEnglish [

	| default |
	default := self defaultTestClass defaultTranslator.
	self assert: default getLanguage equals: 'EN'
]

{ #category : 'tests' }
I18NTranslatorTest >> testGetLanguage [

	self assert: instance getLanguage equals: 'DE'
]

{ #category : 'tests' }
I18NTranslatorTest >> testHasDefaultTranslator [

	self assert: self defaultTestClass defaultTranslator notNil.
	self assert: self defaultTestClass translators notEmpty
]

{ #category : 'tests' }
I18NTranslatorTest >> testTranslationFor [

	self assert: (instance translationFor: #welcome) equals: 'Willkommen'
]

{ #category : 'tests' }
I18NTranslatorTest >> testTranslationForWithMissingTranslationWithBlock [

	self assert: (instance translationFor: #world ifNotFound: [ 'Welt' ]) equals: 'Welt'
]

{ #category : 'tests' }
I18NTranslatorTest >> testTranslationForWithMissingTranslationWithString [

	self assert: (instance translationFor: #world ifNotFound: 'Welt') equals: 'Welt'
]

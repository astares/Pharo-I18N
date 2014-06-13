"
Unit test for I18NTranslator
"
Class {
	#name : #I18NTranslatorTest,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #'I18N-Tests-Core-Translations'
}

{ #category : #accessing }
I18NTranslatorTest >> defaultTestClass [

	^I18NTranslator
]

{ #category : #initialization }
I18NTranslatorTest >> initTestInstance [

	instance := self defaultTestClass new
]

{ #category : #running }
I18NTranslatorTest >> setUp [
	"Set up before running the test"
	
	super setUp.
	self initTestInstance
]

{ #category : #running }
I18NTranslatorTest >> tearDown [
	"Tear down after running a test"
	
	instance := nil.
	super tearDown
]

{ #category : #tests }
I18NTranslatorTest >> testDefaultTranslatorIsEnglish [

	|default|
	default := self defaultTestClass defaultTranslator.
	self assert: default getLanguage = 'EN'
]

{ #category : #tests }
I18NTranslatorTest >> testHasDefaultTranslator [

	self assert: self defaultTestClass defaultTranslator notNil
]

{ #category : #tests }
I18NTranslatorTest >> testHasTranslators [

	self assert: self defaultTestClass translators notEmpty
]

{ #category : #tests }
I18NTranslatorTest >> testLanguages [

	self assert: self defaultTestClass languages notEmpty
]

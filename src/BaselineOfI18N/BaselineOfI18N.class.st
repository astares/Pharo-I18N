Class {
	#name : #BaselineOfI18N,
	#superclass : #BaselineOf,
	#category : #BaselineOfI18N
}

{ #category : #baseline }
BaselineOfI18N >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: 'I18N-Core';
			package: 'I18N-Tests-Core' with: [ spec requires: #('I18N-Core' ) ].
		spec 
			group: 'Core' with: #('I18N-Core' );
			group: 'Tests' with: #('I18N-Tests-Core' );
			group: 'all' with: #('Core' 'Tests' );
			group: 'default' with: #('all' ) ]
]

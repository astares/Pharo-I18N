"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestBaselineOfI18N',
	#superclass : 'PackageManifest',
	#category : 'BaselineOfI18N-Manifest',
	#package : 'BaselineOfI18N',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestBaselineOfI18N class >> ruleClassNotReferencedRuleV1FalsePositive [
	<ignoreForCoverage>

	^ #(#(#(#RGClassDefinition #(#BaselineOfI18N)) #'2024-05-21T13:31:28.453+02:00') )
]

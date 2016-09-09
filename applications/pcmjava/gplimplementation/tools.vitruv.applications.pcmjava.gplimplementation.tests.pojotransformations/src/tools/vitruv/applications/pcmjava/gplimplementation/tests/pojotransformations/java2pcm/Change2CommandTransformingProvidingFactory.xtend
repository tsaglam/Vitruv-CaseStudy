package tools.vitruv.applications.pcmjava.gplimplementation.tests.pojotransformations.java2pcm

import tools.vitruv.framework.change.processing.impl.AbstractChange2CommandTransformingProviding
import tools.vitruv.framework.change.processing.Change2CommandTransformingProviding
import tools.vitruv.applications.pcmjava.gplimplementation.pojotransformations.java2pcm.Change2CommandTransformingJava2PcmGplImplementation

package class Change2CommandTransformingProvidingFactory {
	static def Change2CommandTransformingProviding createJava2PcmGplImplementationTransformingProviding() {
		return AbstractChange2CommandTransformingProviding.createChange2CommandTransformingProviding(
			#[new Change2CommandTransformingJava2PcmGplImplementation()]
		)
	}
}
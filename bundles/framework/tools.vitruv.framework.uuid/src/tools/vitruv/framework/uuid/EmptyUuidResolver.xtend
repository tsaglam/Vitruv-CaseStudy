package tools.vitruv.framework.uuid

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.common.util.URI

class EmptyUuidResolver implements UuidResolver {
	package new() {}
	
	override hasUuid(EObject object) {
		return false;
	}
		
	override hasEObject(String uuid) {
		return false;
	}
	
	override getUuid(EObject object) {
		throw new IllegalStateException("This resolver is empty. Use hasUuid to check that before!");
	}
	
	override getEObject(String uuid) {
		throw new IllegalStateException("This resolver is empty.");
	}
	
	override registerEObject(EObject eObject) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override registerEObject(String uuid, EObject eObject) {
		throw new UnsupportedOperationException("This resolver is empty.");
	}
	
	override getResourceSet() {
		throw new UnsupportedOperationException("This resolver is empty.");
	}
	
	override registerUuidForGlobalUri(String uuid, URI uri) {
		return true;
	}
	
	override getPotentiallyCachedEObject(String uuid) {
		throw new IllegalStateException("This resolver is empty.");
	}
	
	override hasPotentiallyCachedEObject(String uuid) {
		return false;
	}
	
	override getPotentiallyCachedUuid(EObject eObject) {
		throw new IllegalStateException("This resolver is empty. Use hasUuid to check that before!");
	}
	
	override registerCachedEObject(EObject eObject) {
		throw new UnsupportedOperationException("This resolver is empty.");
	}
	
	override hasPotentiallyCachedUuid(EObject eObject) {
		return false;
	}
	
	override loadUuidsToChild(UuidResolver childResolver, URI uri) {
		// Do nothing, as there are no entries
	}
	
}
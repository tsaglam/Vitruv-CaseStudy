/**
 */
package tools.vitruv.framework.versioning.tests;

import junit.framework.Test;
import junit.framework.TestSuite;

import junit.textui.TestRunner;
import tools.vitruv.framework.versioning.author.tests.AuthorTests;
import tools.vitruv.framework.versioning.commit.tests.CommitTests;
import tools.vitruv.framework.versioning.repository.tests.RepositoryTests;

/**
 * <!-- begin-user-doc -->
 * A test suite for the '<em><b>Model</b></em>' model.
 * <!-- end-user-doc -->
 * @generated
 */
public class ModelAllTests extends TestSuite {

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static void main(String[] args) {
		TestRunner.run(suite());
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 */
	public static Test suite() {
		TestSuite suite = new ModelAllTests("Model Tests");
		suite.addTest(VersioningTests.suite());
		suite.addTest(CommitTests.suite());
		suite.addTest(RepositoryTests.suite());
		suite.addTest(AuthorTests.suite());
		// suite.addTest(ConflictTests.suite());
		// suite.addTest(BranchTests.suite());
		return suite;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public ModelAllTests(String name) {
		super(name);
	}

} //ModelAllTests
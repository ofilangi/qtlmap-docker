/** \file tb2wcsp.hpp
 *  \brief Weighted constraint satisfaction problem modeling and local reasoning
 *
 */

#ifndef TB2WCSP_HPP_
#define TB2WCSP_HPP_

#include "toulbar2.hpp"
#include "tb2variable.hpp"
#include "tb2constraint.hpp"

class BinaryConstraint;
class TernaryConstraint;
class NaryConstraint;
class VACExtension;
class TreeDecomposition;

class GlobalConstraint;
class FlowBasedGlobalConstraint;
class AllDiffConstraint;
class GlobalCardinalityConstraint;
class SameConstraint;
class RegularConstraint;

/** Concrete class WCSP containing a weighted constraint satisfaction problem
 *	- problem lower and upper bound
 *	- list of variables
 *	- list of cost functions (created before and during search by variable elimination) composed of constrs, elimBinConstrs, and elimTernConstrs
 *	- propagation queues (variable-based except for separators)
 *	- data for bounded variable elimination during search (limited to degree at most two)
 *
 * \note In most WCSP member functions, variables are referenced by their lexicographic index number (position in WCSP::vars vector, as returned by \e eg WCSP::makeEnumeratedVariable)
 *
 */

class WCSP : public WeightedCSP {
	static int wcspCounter; 			///< count the number of instances of WCSP class
	int instance; 						///< instance number
	string name; 						///< problem name
	Store *storeData; 					///< backtrack management system and data
	StoreCost lb; 						///< current problem lower bound
	Cost ub; 							///< current problem upper bound
	StoreCost negCost;					///< shifting value to be added to problem lowerbound when computing the partition function
	vector<Variable *> vars; 			///< list of all variables
	vector<Value> bestValues; 			///< hint for some value ordering heuristics (ONLY used by RDS)
	vector<Value> solution; 			///< remember last solution found
	vector<Constraint *> constrs; 		///< list of original cost functions
	int NCBucketSize; 					///< number of buckets for NC bucket sort
	vector< VariableList > NCBuckets;	///< NC buckets: vector of backtrackable lists of variables
	Queue NC;							///< NC queue (non backtrackable list)
	Queue IncDec;						///< BAC queue (non backtrackable list)
	Queue AC;							///< AC queue (non backtrackable list)
	Queue DAC;							///< DAC queue (non backtrackable list)
	Queue EAC1;							///< EAC intermediate queue (non backtrackable list)
	Queue EAC2;							///< EAC queue (non backtrackable list)
	Queue Eliminate;					///< Variable Elimination queue (non backtrackable list)
	SeparatorList PendingSeparator;		///< List of pending separators for BTD-like methods (backtrackable list)
	bool objectiveChanged;				///< flag if lb or ub has changed (NC propagation needs to be done)
	Long nbNodes;                       ///< current number of calls to propagate method (roughly equal to number of search nodes), used as a time-stamp by Queue methods
	Constraint *lastConflictConstr;		///< hook for last conflict variable heuristic
	int maxdomainsize;					///< maximum initial domain size found in all variables
	vector<GlobalConstraint*> globalconstrs;	///< a list of all original global constraints (also inserted in constrs)

	vector< vector<int> > listofsuccessors; ///< list of topologic order of var used when q variables are  added for decomposing global constraint (berge acyclic)

	// make it private because we don't want copy nor assignment
	WCSP(const WCSP &wcsp);
	WCSP& operator=(const WCSP &wcsp);

public:
	/// \brief variable elimination information used in backward phase to get a solution during search
	/// \warning restricted to at most two neighbor variables
	typedef struct {
		EnumeratedVariable* x;		///< eliminated variable
		EnumeratedVariable* y;		///< first neighbor variable if any
		EnumeratedVariable* z;		///< second neighbor variable if any
		BinaryConstraint*   xy;		///< corresponding binary cost function if any
		BinaryConstraint*   xz;		///< corresponding binary cost function if any
		TernaryConstraint*  xyz;	///< corresponding ternary cost function if any
	    Constraint*         ctr;    ///< corresponding sum/join cost function if using generic variable elimination
	} elimInfo;

	StoreInt elimOrder;					///< current number of eliminated variables
	vector<elimInfo> elimInfos;			///< variable elimination information used in backward phase to get a solution
	StoreInt elimBinOrder;				///< current number of extra binary cost functions consumed in the corresponding pool
	StoreInt elimTernOrder;				///< current number of extra ternary cost functions consumed in the corresponding pool
	vector<Constraint*>  elimBinConstrs;	///< pool of (fresh) binary cost functions
	vector<Constraint*>  elimTernConstrs;	///< pool of (fresh) ternary cost functions
	int maxDegree;						///< maximum degree of eliminated variables found in preprocessing
    Long elimSpace;                     ///< estimate of total space required for generic variable elimination

	VACExtension*  vac;					///< link to VAC management system

#ifdef XMLFLAG
	map<int,int> varsDom;				///< structures for solution translation: we don't have to parse the XML file again
	vector< vector<int> > Doms;			///< structures for solution translation: we don't have to parse the XML file again
#endif

	WCSP(Store *s, Cost upperBound);

	virtual ~WCSP();

	// -----------------------------------------------------------
	// General API for weighted CSP global constraint

	int getIndex() const {return instance;}		///< \brief instantiation occurrence number of current WCSP object
	string getName() const {return name;}

	Cost getLb() const {return lb;}				///< \brief gets problem lower bound
	Cost getUb() const {return ub;}				///< \brief gets problem upper bound

	void setUb(Cost newUb) { ub = newUb; }		///< \internal sets problem lower bound
	void setLb(Cost newLb) { lb = newLb; }		///< \internal sets problem upper bound

	/// \brief sets problem upper bound when a new solution is found
	/// \warning side-effect: adjusts maximum number of buckets (see \ref ncbucket) if called before modeling a problem
	void updateUb(Cost newUb) {
		if (newUb < ub) {
			ub = newUb;
			if (vars.size()==0) NCBucketSize = cost2log2gub(ub) + 1;
		}
	}

	/// \brief enforces problem upper bound when exploring an alternative search node
	void enforceUb() {
		if (CUT((((lb % ToulBar2::costMultiplier) != MIN_COST)?(lb + ToulBar2::costMultiplier):lb), ub)) THROWCONTRADICTION;
		objectiveChanged=true;
	}

	/// \brief sets problem upper bound and asks for propagation
	void decreaseUb(Cost newUb) {
		if (newUb < ub) {
			if (CUT((((lb % ToulBar2::costMultiplier) != MIN_COST)?(lb + ToulBar2::costMultiplier):lb), newUb)) THROWCONTRADICTION;
			ub = newUb;
			objectiveChanged=true;
		}
	}

	/// \brief increases problem lower bound thanks to \e eg soft local consistencies
	/// \param addLb increment value to be \b added to the problem lower bound
	void increaseLb(Cost addLb) {
		assert(addLb >= MIN_COST);
		if (addLb > MIN_COST) {
			//		   incWeightedDegree(addLb);
			Cost newLb = lb + addLb;
			if (CUT((((newLb % ToulBar2::costMultiplier) != MIN_COST)?(newLb + ToulBar2::costMultiplier):newLb), ub)) THROWCONTRADICTION;
			lb = newLb;
			objectiveChanged=true;
			if (ToulBar2::setminobj) (*ToulBar2::setminobj)(getIndex(), -1, newLb);
		}
	}

	void decreaseLb(Cost cost) { assert(cost <= MIN_COST); negCost += cost; }
	Cost getNegativeLb() const { return negCost; }

	bool enumerated(int varIndex) const {return vars[varIndex]->enumerated();}	///< \brief true if the variable has an enumerated domain

	string getName(int varIndex) const {return vars[varIndex]->getName();}		///< \note by default, variables names are integers, starting at zero
	Value getInf(int varIndex) const {return vars[varIndex]->getInf();}			///< \brief minimum current domain value
	Value getSup(int varIndex) const {return vars[varIndex]->getSup();}			///< \brief maximum current domain value
	Value getValue(int varIndex) const {return vars[varIndex]->getValue();}		///< \brief current assigned value \warning undefined if not assigned yet
	unsigned int getDomainSize(int varIndex) const {return vars[varIndex]->getDomainSize();}	///< \brief current domain size
	bool getEnumDomain(int varIndex, Value *array);
	bool getEnumDomainAndCost(int varIndex, ValueCost *array);
	int getDACOrder(int varIndex) const {return vars[varIndex]->getDACOrder();} ///< \brief index of the variable in the DAC variable ordering
	void updateCurrentVarsId();	///< \brief determines the position of each variable in the current list of unassigned variables (see \ref WCSP::dump)

	bool assigned(int varIndex) const {return vars[varIndex]->assigned();}
	bool unassigned(int varIndex) const {return vars[varIndex]->unassigned();}
	bool canbe(int varIndex, Value v) const {return vars[varIndex]->canbe(v);}
	bool cannotbe(int varIndex, Value v) const {return vars[varIndex]->cannotbe(v);}

	void increase(int varIndex, Value newInf) {vars[varIndex]->increase(newInf);}	///< \brief changes domain lower bound
	void decrease(int varIndex, Value newSup) {vars[varIndex]->decrease(newSup);}	///< \brief changes domain upper bound
	void assign(int varIndex, Value newValue) {vars[varIndex]->assign(newValue);}	///< \brief assigns a variable and immediately propagates this assignment
	void remove(int varIndex, Value remValue) {vars[varIndex]->remove(remValue);}	///< \brief removes a domain value

	/// \brief assigns a set of variables at once and propagates
	/// \param varIndexes vector of variable indexes as returned by makeXXXVariable
	/// \param newValues vector of values to be assigned to the corresponding variables
	/// \note this function is equivalent but faster than a sequence of \ref WCSP::assign. it is particularly useful for Local Search methods such as Large Neighborhood Search.
	void assignLS(vector<int>& varIndexes, vector<Value>& newValues) {
		assert(varIndexes.size()==newValues.size());
		unsigned int size = varIndexes.size();
		set<Constraint *> delayedctrs;
		for (unsigned int i=0; i<size; i++) vars[varIndexes[i]]->assignLS(newValues[i], delayedctrs);
		for (set<Constraint *>::iterator it = delayedctrs.begin(); it != delayedctrs.end(); ++it) (*it)->propagate();
	}

	Cost getUnaryCost(int varIndex, Value v) const {return vars[varIndex]->getCost(v);}			///< \brief unary cost associated to a domain value
	Cost getMaxUnaryCost(int varIndex) const {return vars[varIndex]->getMaxCost();}				///< \brief maximum unary cost in the domain
	Value getMaxUnaryCostValue(int varIndex) const {return vars[varIndex]->getMaxCostValue();}	///< \brief a value having the maximum unary cost in the domain
	Value getSupport(int varIndex) const {return vars[varIndex]->getSupport();}					///< \brief unary (NC/EAC) support value
	Value getBestValue(int varIndex) const {return bestValues[varIndex];}						///< \brief hint for some value ordering heuristics (ONLY used by RDS)
	void setBestValue(int varIndex, Value v) {bestValues[varIndex] = v;}						///< \brief hint for some value ordering heuristics (ONLY used by RDS)

	int getDegree(int varIndex) const {return vars[varIndex]->getDegree();}						///< \brief approximate degree of a variable (\e ie number of active cost functions, see \ref varelim)
	int getTrueDegree(int varIndex) const {return vars[varIndex]->getTrueDegree();}				///< \brief degree of a variable
	Long getWeightedDegree(int varIndex) const {return vars[varIndex]->getWeightedDegree();}	///< \brief weighted degree heuristic
	void revise(Constraint *c) {lastConflictConstr = c;}										///< \internal last conflict heuristic
	/// \internal last conflict heuristic
	void conflict() {
		if (lastConflictConstr) {
			if (ToulBar2::verbose>=2) cout << "Last conflict on " << *lastConflictConstr << endl;
			lastConflictConstr->incConflictWeight(lastConflictConstr);
			lastConflictConstr=NULL;
		}
	}
	/// \internal \deprecated
	void incWeightedDegree(Long incval) {
		if (lastConflictConstr) {
			lastConflictConstr->incConflictWeight(incval);
		}
	}

	void whenContradiction();       ///< \brief after a contradiction, resets propagation queues and increases \ref WCSP::nbNodes
	void propagate();               ///< \brief propagates until a fix point is reached (or throws a contradiction) and then increases \ref WCSP::nbNodes
	bool verify();					///< \brief checks the propagation fix point is reached

	int getMaxDomainSize() { return maxdomainsize;}					///< \brief maximum initial domain size found in all variables
	unsigned int numberOfVariables() const {return vars.size();}	///< \brief current number of unassigned variables
	/// \brief returns current number of unassigned variables
	unsigned int numberOfUnassignedVariables() const {
		int res = 0;
		for (unsigned int i=0; i<vars.size(); i++) if (unassigned(i)) res++;
		return res;}
	unsigned int numberOfConstraints() const {return constrs.size();}	///< \brief initial number of cost functions
	unsigned int numberOfConnectedConstraints() const;				///< \brief current number of cost functions
	unsigned int numberOfConnectedBinaryConstraints() const;		///< \brief current number of binary cost functions
	unsigned int medianDomainSize() const;							///< \brief median current domain size of variables
	unsigned int medianDegree() const;								///< \brief median current degree of variables
	Value getDomainSizeSum();										///< \brief total sum of current domain sizes
	/// \brief Cartesian product of current domain sizes
	/// \param cartesianProduct result obtained by the GNU Multiple Precision Arithmetic Library GMP
	void cartProd(BigInteger& cartesianProduct) {
		for(vector<Variable*>::iterator it=vars.begin(); it!=vars.end();it++)
		{
			Variable * x = *it;
			mpz_mul_si(cartesianProduct.integer, cartesianProduct.integer, x->getDomainSize());
		}
	}
#ifdef BOOST
	int diameter();					///< \deprecated
	int connectedComponents();		///< \deprecated
	int biConnectedComponents();	///< \deprecated
	void minimumDegreeOrdering();	///< \deprecated
#endif

	/// \defgroup modeling Variable and cost function modeling
	/// Modeling a Weighted CSP consists in creating variables and cost functions.\n
	/// Domains of variables can be of two different types:
	/// - enumerated domain allowing direct access to each value (array) and iteration on current domain in times proportional to the current number of values (double-linked list)
	/// - interval domain represented by a lower value and an upper value only (useful for large domains)
	/// \warning Current implementation of toulbar2 has limited modeling and solving facilities for interval domains.
	/// There is no cost functions accepting both interval and enumerated variables for the moment, which means all the variables should have the same type.
	///
	/// \addtogroup modeling
	/// Cost functions can be defined in extension (table or maps) or having a specific semantic.\n
	/// Cost functions in extension depend on their arity:
	/// - unary cost function (directly associated to an enumerated variable)
	/// - binary and ternary cost functions (table of costs)
	/// - n-ary cost functions (n >= 4) defined by a list of tuples with associated costs and a default cost for missing tuples (allows compact representation)
	///
	/// Cost functions having a specific semantic are:
	/// - simple arithmetic and scheduling (temporal disjunction) cost functions on interval variables
	/// - global cost functions (\e eg soft alldifferent, soft global cardinality constraint, soft same, soft regular)
	/// \warning Current implementation of toulbar2 has limited solving facilities for global cost functions (no BTD-like methods nor variable elimination)

	int makeEnumeratedVariable(string n, Value iinf, Value isup);
	int makeEnumeratedVariable(string n, Value *d, int dsize);
	int makeIntervalVariable(string n, Value iinf, Value isup);

	void postUnary(int xIndex, vector<Cost> &costs);
	int postUnary(int xIndex, Value *d, int dsize, Cost penalty);
	int postSupxyc(int xIndex, int yIndex, Value cst, Value deltamax = MAX_VAL-MIN_VAL);
	int postDisjunction(int xIndex, int yIndex, Value cstx, Value csty, Cost penalty);
	int postSpecialDisjunction(int xIndex, int yIndex, Value cstx, Value csty, Value xinfty, Value yinfty, Cost costx, Cost costy);
	int postBinaryConstraint(int xIndex, int yIndex, vector<Cost> &costs);
	int postTernaryConstraint(int xIndex, int yIndex, int zIndex, vector<Cost> &costs);
	int postNaryConstraintBegin(int* scopeIndex, int arity, Cost defval); /// \warning must call postNaryConstraintEnd after giving cost tuples
	void postNaryConstraintTuple(int ctrindex, Value* tuple, int arity, Cost cost);
	void postNaryConstraintTuple(int ctrindex, String& tuple, Cost cost);
	void postNaryConstraintEnd(int ctrindex) {getCtr(ctrindex)->propagate();}
	int postGlobalConstraint(int* scopeIndex, int arity, string &name, ifstream &file);
	bool isGlobal() {return (globalconstrs.size() > 0);} ///< \brief true if there are soft global constraints defined in the problem

	void read_wcsp(const char *fileName); 		///< \brief load problem in native wcsp format (\ref wcspformat)
	void read_uai2008(const char *fileName);	///< \brief load problem in UAI 2008 format (see http://graphmod.ics.uci.edu/uai08/FileFormat and http://www.cs.huji.ac.il/project/UAI10/fileFormat.php) \warning UAI10 evidence file format not recognized by toulbar2 as it does not allow multiple evidence (you should remove the first value in the file)
	void read_random(int n, int m, vector<int>& p, int seed, bool forceSubModular = false );	///< \brief create a random WCSP with \e n variables, domain size \e m, array \e p where the first element is a percentage of tuples with a nonzero cost and next elements are the number of random cost functions for each different arity (starting with arity two), random seed, and a flag to have a percentage (last element in the array \e p) of the binary cost functions being permutated submodular
	void read_wcnf(const char *fileName);		///< \brief load problem in (w)cnf format (see http://www.maxsat.udl.cat/08/index.php?disp=requirements)
	void read_qpbo(const char *fileName);		///< \brief load quadratic pseudo-Boolean optimization problem in unconstrained quadratic programming text format (first text line with n, number of variables and m, number of triplets, followed by the m triplets (x,y,cost) describing the sparse symmetric nXn cost matrix with variable indexes such that x <= y and any positive or negative real numbers for costs)

	void read_XML(const char *fileName);		///< \brief load problem in XML format (see http://www.cril.univ-artois.fr/~lecoutre/benchmarks.html)
	void solution_XML( bool opt = false );		///< \brief output solution in Max-CSP 2008 output format
    void solution_UAI(Cost res, TAssign *sol = NULL, bool opt = false );				///< \brief output solution in UAI 2008 output format
    vector<Value> &getSolution() {return solution;}
    void setSolution(TAssign *sol = NULL) {for (unsigned int i=0; i<numberOfVariables(); i++) {solution[i] = ((sol!=NULL)?(*sol)[i]:getValue(i));}}
    void printSolution(ostream &os) {for (unsigned int i=0; i<numberOfVariables(); i++) {os << " " << solution[i];}}

	void print(ostream& os);								///< \brief print current domains and active cost functions (see \ref verbosity)
	void dump(ostream& os, bool original = true);			///< \brief output the current WCSP into a file in wcsp format \param os output file \param original if true then keeps all variables with their original domain size else uses unassigned variables and current domains recoding variable indexes
	friend ostream& operator<<(ostream& os, WCSP &wcsp);	///< \relates WCSP::print


	// -----------------------------------------------------------
	// Specific API for Variable and Constraint classes

	Store *getStore() {return storeData;}
	Variable   *getVar(int varIndex) const {return vars[varIndex];}
	Constraint *getCtr(int ctrIndex) const {
		if (ctrIndex>=0) {
			return constrs[ctrIndex];
		} else {
			if (-ctrIndex-1 >= MAX_ELIM_BIN) {
				return elimTernConstrs[-ctrIndex-1 - MAX_ELIM_BIN];
			} else {
				return elimBinConstrs[-ctrIndex-1];
			}
		}
	}

	void link(Variable *x) {vars.push_back(x); bestValues.push_back(x->getSup()+1); solution.push_back(x->getSup()+1);}
	void link(Constraint *c) {constrs.push_back(c);}

	VariableList* getNCBucket( int ibucket ) { return &NCBuckets[ibucket]; }
	int getNCBucketSize() const {return NCBucketSize;}
	void changeNCBucket(int oldBucket, int newBucket, DLink<Variable *> *elt) {
		assert(newBucket < NCBucketSize);
		if (oldBucket >= 0) NCBuckets[oldBucket].erase(elt, true);
		if (newBucket >= 0) NCBuckets[newBucket].push_back(elt, true);
	}
	void printNCBuckets();

	Long getNbNodes() {return nbNodes;}

	void queueNC(DLink<VariableWithTimeStamp> *link) {NC.push(link, nbNodes);}
	void queueInc(DLink<VariableWithTimeStamp> *link) {IncDec.push(link, INCREASE_EVENT, nbNodes);}
	void queueDec(DLink<VariableWithTimeStamp> *link) {IncDec.push(link, DECREASE_EVENT, nbNodes);}
	void queueAC(DLink<VariableWithTimeStamp> *link) {AC.push(link, nbNodes);}
	void queueDAC(DLink<VariableWithTimeStamp> *link) {DAC.push(link, nbNodes);}
	void queueEAC1(DLink<VariableWithTimeStamp> *link) {EAC1.push(link, nbNodes);}
	void queueEAC2(DLink<VariableWithTimeStamp> *link) {EAC2.push(link, nbNodes);}
	void queueEliminate(DLink<VariableWithTimeStamp> *link) { Eliminate.push(link, nbNodes);  }
	void queueSeparator(DLink<Separator *> *link) { PendingSeparator.push_back(link, true); }
	void unqueueSeparator(DLink<Separator *> *link) { PendingSeparator.erase(link, true); }

	void propagateNC();			///< \brief removes forbidden values
	void propagateIncDec();		///< \brief ensures unary bound arc consistency supports (remove forbidden domain bounds)
	void propagateAC();			///< \brief ensures unary and binary and ternary arc consistency supports
	void propagateDAC();		///< \brief ensures unary and binary and ternary directed arc consistency supports
	void fillEAC2();
	Queue *getQueueEAC1() {return &EAC1;}
	void propagateEAC();		///< \brief ensures unary existential arc consistency supports
	void propagateSeparator();	///< \brief exploits graph-based learning

	/// \brief sorts the list of constraints associated to each variable based on smallest problem variable indexes
	/// \warning side-effect: updates DAC order according to an existing variable elimination order
	void sortConstraints();

	/// \brief applies preprocessing techniques before the search (depending on toublar2 options)
	/// \warning to be done \b only before the search
	void preprocessing();

	// -----------------------------------------------------------
	// Methods for Variable Elimination

	void initElimConstr();
	void initElimConstrs();

	int getElimOrder() { return (int) elimOrder; }
	int getElimBinOrder() { return (int) elimBinOrder; }
	int getElimTernOrder() { return (int) elimTernOrder; }
	void elimOrderInc() { elimOrder = elimOrder + 1; }
	void elimBinOrderInc() { elimBinOrder = elimBinOrder + 1; }
	void elimTernOrderInc() { elimTernOrder = elimTernOrder + 1; }
	Constraint *getElimBinCtr(int elimBinIndex) const {return elimBinConstrs[elimBinIndex];}
	Constraint *getElimTernCtr(int elimTernIndex) const {return elimTernConstrs[elimTernIndex];}

	BinaryConstraint* newBinaryConstr( EnumeratedVariable* x, EnumeratedVariable* y, Constraint *from1 = NULL,  Constraint *from2 = NULL );
	TernaryConstraint* newTernaryConstr( EnumeratedVariable* x, EnumeratedVariable* y, EnumeratedVariable* z, Constraint *from1 = NULL );
	TernaryConstraint* newTernaryConstr( EnumeratedVariable* x, EnumeratedVariable* y, EnumeratedVariable* z, vector<Cost> costs );

	void eliminate();
	void restoreSolution( Cluster* c = NULL );

	Constraint* sum( Constraint* ctr1, Constraint* ctr2  );
	void project( Constraint* &ctr_inout, EnumeratedVariable* var  );
	void variableElimination( EnumeratedVariable* var );

	void processTernary();				///< \brief projects&subtracts ternary cost functions (see \ref preprocessing)
	void ternaryCompletion();
	bool kconsistency(int xIndex, int yIndex, int zIndex, BinaryConstraint* xy, BinaryConstraint* yz, BinaryConstraint* xz );

	// -----------------------------------------------------------
	// Data and methods for Virtual Arc Consistency

	void histogram( Cost c );
	/// \brief initializes histogram of costs used by Virtual Arc Consistency to speed up its convergence (Bool_\theta of P)
    void histogram();
	void iniSingleton();
	void updateSingleton();
	void removeSingleton();
	void printVACStat();
	int  getVACHeuristic();

	// -----------------------------------------------------------
	// Data and methods for Cluster Tree Decomposition

	TreeDecomposition* td;
	TreeDecomposition* getTreeDec()  { return td; }
	void buildTreeDecomposition();
	void elimOrderFile2Vector(char *elimVarOrder, vector<int> &order);
	void setDACOrder(vector<int> &elimVarOrder);

	// dac order reordering when Berge acyclic gobal constraint are present in the wcsp
	// 
	void visit(int i, vector <int>&revdac, vector <bool>& marked, const vector< vector<int> >&listofsuccessors );

	// -----------------------------------------------------------
	// Functions dealing with probabilities
	// warning: ToulBar2::NormFactor has to be initialized

	Cost Prob2Cost(TProb p) const;
	TProb Cost2Prob(Cost c) const;
	TProb Cost2LogLike(Cost c) const;
	Cost LogLike2Cost(TProb p) const;
	Cost SumLogLikeCost(Cost c1, Cost c2) const;
	TProb SumLogLikeCost(TProb logc1, Cost c2) const;
};

#endif /*TB2WCSP_HPP_*/

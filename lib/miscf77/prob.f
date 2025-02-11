*
* $Id: prob.F,v 1.1.1.1 1996/04/01 15:02:41 mclareni Exp $
*
* $Log: prob.F,v $
* Revision 1.1.1.1  1996/04/01 15:02:41  mclareni
* Mathlib gen
*
*
      FUNCTION PROB(X,N)
 
*
* $Id: imp64.inc,v 1.1.1.1 1996/04/01 15:02:59 mclareni Exp $
*
* $Log: imp64.inc,v $
* Revision 1.1.1.1  1996/04/01 15:02:59  mclareni
* Mathlib gen
*
*
* imp64.inc
*
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL PROB,X
      CHARACTER NAME*(*)
      CHARACTER*80 ERRTXT
      PARAMETER (NAME = 'PROB')
      PARAMETER (R1 = 1, HF = R1/2, TH = R1/3, F1 = 2*R1/9)
      PARAMETER (C1 = 1.12837 91670 95513D0)
      PARAMETER (NMAX = 300)
*                maximum chi2 per df for df >= 2., if chi2/df > chipdf prob=0.
      PARAMETER (CHIPDF = 100.)
      PARAMETER (XMAX = 174.673, XMAX2 = 2*XMAX)
      PARAMETER (XLIM = 24.)
      PARAMETER (EPS = 1D-30)
      GERFC(V)=DERFC(V)
 
      Y=X
      U=HF*Y
      IF(N .LE. 0) THEN
       H=0
       WRITE(0,101) N
!       CALL MTLPRT(NAME,'G100.1',ERRTXT)
      ELSEIF(Y .LT. 0) THEN
       H=0
        WRITE(0,102) X
!       CALL MTLPRT(NAME,'G100.2',ERRTXT)
      ELSEIF(Y .EQ. 0 .OR. N/20 .GT. Y) THEN
       H=1
      ELSEIF(N .EQ. 1) THEN
       W=SQRT(U)
       IF(W .LT. XLIM) THEN
        H=GERFC(W)
       ELSE
        H=0
       ENDIF
      ELSEIF(N .GT. NMAX) THEN
       S=R1/N
       T=F1*S
       W=((Y*S)**TH-(1-T))/SQRT(2*T)
       IF(W .LT. -XLIM) THEN
        H=1
       ELSEIF(W .LT. XLIM) THEN
        H=HF*GERFC(W)
       ELSE
        H=0
       ENDIF
      ELSE
       M=N/2
       IF(U .LT. XMAX2 .AND. (Y/N).LE.CHIPDF ) THEN
        S=EXP(-HF*U)
        T=S
        E=S
        IF(2*M .EQ. N) THEN
         FI=0
         DO 1 I = 1,M-1
         FI=FI+1
         T=U*T/FI
    1    S=S+T
         H=S*E
        ELSE
         FI=1
         DO 2 I=1,M-1
         FI=FI+2
         T=T*Y/FI
    2    S=S+T
         W=SQRT(U)
         IF(W.LT.XLIM) THEN
          H=C1*W*S*E+GERFC(W)
         ELSE
          H=0.
         ENDIF
        ENDIF
       ELSE
        H=0
       ENDIF
      ENDIF
      IF ( H.GT. EPS ) THEN
         PROB=H
      ELSE
         PROB=0.
      ENDIF
      RETURN
  101 FORMAT('N = ',I6,' < 1')
  102 FORMAT('X = ',1P,E20.10,' < 0')
      END

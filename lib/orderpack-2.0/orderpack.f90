Module m_ctrper
Use m_mrgrnk
Private
Integer, Parameter :: kdp = selected_real_kind(15)
public :: ctrper
private :: kdp
private :: R_ctrper, I_ctrper, D_ctrper
interface ctrper
  module procedure d_ctrper, r_ctrper, i_ctrper
end interface ctrper
contains

Subroutine D_ctrper (XDONT, PCLS)
!   Permute array XVALT randomly, but leaving elements close
!   to their initial locations (nearbyness is controled by PCLS).
! _________________________________________________________________
!   The routine takes the 1...size(XVALT) index array as real
!   values, takes a combination of these values and of random
!   values as a perturbation of the index array, and sorts the
!   initial set according to the ranks of these perturbated indices.
!   The relative proportion of initial order and random order
!   is 1-PCLS / PCLS, thus when PCLS = 0, there is no change in
!   the order whereas the new order is fully random when PCLS = 1.
!   Michel Olagnon - May 2000.
! _________________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*(/ (Real(I), I=1,size(XDONT)) /)
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine D_ctrper

Subroutine R_ctrper (XDONT, PCLS)
!   Permute array XVALT randomly, but leaving elements close
!   to their initial locations (nearbyness is controled by PCLS).
! _________________________________________________________________
!   The routine takes the 1...size(XVALT) index array as real
!   values, takes a combination of these values and of random
!   values as a perturbation of the index array, and sorts the
!   initial set according to the ranks of these perturbated indices.
!   The relative proportion of initial order and random order
!   is 1-PCLS / PCLS, thus when PCLS = 0, there is no change in
!   the order whereas the new order is fully random when PCLS = 1.
!   Michel Olagnon - May 2000.
! _________________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (InOut) :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*(/ (Real(I), I=1,size(XDONT)) /)
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine R_ctrper
Subroutine I_ctrper (XDONT, PCLS)
!   Permute array XVALT randomly, but leaving elements close
!   to their initial locations (nearbyness is controled by PCLS).
! _________________________________________________________________
!   The routine takes the 1...size(XVALT) index array as real
!   values, takes a combination of these values and of random
!   values as a perturbation of the index array, and sorts the
!   initial set according to the ranks of these perturbated indices.
!   The relative proportion of initial order and random order
!   is 1-PCLS / PCLS, thus when PCLS = 0, there is no change in
!   the order whereas the new order is fully random when PCLS = 1.
!   Michel Olagnon - May 2000.
! _________________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (InOut)  :: XDONT
      Real, Intent (In) :: PCLS
! __________________________________________________________
!
      Real, Dimension (Size(XDONT)) :: XINDT
      Integer, Dimension (Size(XDONT)) :: JWRKT
      Real :: PWRK
      Integer :: I
!
      Call Random_number (XINDT(:))
      PWRK = Min (Max (0.0, PCLS), 1.0)
      XINDT = Real(Size(XDONT)) * XINDT
      XINDT = PWRK*XINDT + (1.0-PWRK)*(/ (Real(I), I=1,size(XDONT)) /)
      Call MRGRNK (XINDT, JWRKT)
      XDONT = XDONT (JWRKT)
!
End Subroutine I_ctrper
end module m_ctrper
Module m_fndnth
Integer, Parameter :: kdp = selected_real_kind(15)
public :: fndnth
private :: kdp
private :: R_fndnth, I_fndnth, D_fndnth
interface fndnth
  module procedure d_fndnth, r_fndnth, i_fndnth
end interface fndnth
contains

Function D_fndnth (XDONT, NORD) Result (FNDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! ______________________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It is faster when NORD is very small (2-5),
!  and it requires only a workarray of size NORD and type of XDONT,
!  but worst case behavior can happen fairly probably (initially inverse
!  sorted). In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Real (Kind=kdp), Dimension (:), Intent (In) :: XDONT
      Real (Kind=kdp) :: FNDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (Kind=kdp), Dimension (NORD) :: XWRKT
      Real (Kind=kdp) :: XWRK, XWRK1
!
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1

!
End Function D_fndnth

Function R_fndnth (XDONT, NORD) Result (FNDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! ______________________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It is faster when NORD is very small (2-5),
!  and it requires only a workarray of size NORD and type of XDONT,
!  but worst case behavior can happen fairly probably (initially inverse
!  sorted). In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Real :: FNDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real, Dimension (NORD) :: XWRKT
      Real :: XWRK, XWRK1
!
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1

!
End Function R_fndnth
Function I_fndnth (XDONT, NORD) Result (FNDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! ______________________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It is faster when NORD is very small (2-5),
!  and it requires only a workarray of size NORD and type of XDONT,
!  but worst case behavior can happen fairly probably (initially inverse
!  sorted). In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In) :: XDONT
      Integer :: fndnth
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer, Dimension (NORD) :: XWRKT
      Integer :: XWRK, XWRK1
!
!
      Integer :: ICRS, IDCR, ILOW, NDON
!
      XWRKT (1) = XDONT (1)
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XWRKT(IDCR)) Exit
            XWRKT (IDCR+1) = XWRKT (IDCR)
         End Do
         XWRKT (IDCR+1) = XWRK
      End Do
!
      NDON = SIZE (XDONT)
      XWRK1 = XWRKT (NORD)
      ILOW = 2*NORD - NDON
      Do ICRS = NORD + 1, NDON
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, MAX (1, ILOW) , - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
            XWRK1 = XWRKT(NORD)
         End If
         ILOW = ILOW + 1
      End Do
      FNDNTH = XWRK1

!
End Function I_fndnth
end module m_fndnth
Program follow
!  Question From Colin Thefleau:
! 
! I have a small problem that my cloudy brain can't solve:
! Say I have a bunch of coordinates (realx(i), realy(i)) that form a circle 
! (or any closed form) if every point is plotted. I have to sort them so that 
! they "ride" the circle in one direction. For example beginning at one point 
! (the highest point for example), and go in the clock drive direction.
! Has someone an idea how this is to be done?  Or where can I find a sample 
! code for inspiration? I am really new to fortran and really can't find a 
! solution.
! --------------------------------------------------------------------------
! The following program is an attempt to answer that question for a
! "reasonable" profile. From the current point, it finds the "nearest"
! point in the set of remaining ones according to some weighted distance,
! weights penalizing the direction that one is coming from.
!
   integer, parameter :: nmax = 200
   real, dimension (nmax) :: xptst, yptst, xtmpt, ytmpt, xrndt
   integer, dimension (nmax) :: irndt
   real :: t, xtmp, ytmp, xunt, yunt, xori, yori, xvec, yvec, wdst, wdst0, &
           xlen, xang, xunt1, yunt1
   integer :: imin, imax, ipnt, inxt, itst
!
!  take a continuous curve and make the order random
!
   call random_number (xrndt)
   call mrgrnk (xrndt, irndt)
!
   do ipnt = 1, nmax
     t = 6.28318 * real (ipnt) / real (nmax)
     xtmpt (ipnt) = (5.+ 2 * cos (4.*t))*cos(t)
     ytmpt (ipnt) = -(5.+ 2 * cos (4.*t))*sin(t)
   enddo
   xptst = xtmpt (irndt)
   yptst = ytmpt (irndt)
!
! Bring starting point (Northmost) to first position
!
   imin = sum (maxloc(yptst))
   xtmp = xptst (1)
   ytmp = yptst (1)
   xptst (1) = xptst (imin)
   yptst (1) = yptst (imin)
   xptst (imin) = xtmp
   yptst (imin) = ytmp
!
! unit vector in the current direction (east)
!
   xunt = 1.
   yunt = 0.
!
! Find next point in line
!
   nextpoint: do inxt = 2, nmax-1
      xori = xptst (inxt-1)
      yori = yptst (inxt-1)
      wdst0 = huge(wdst)
      do itst = inxt, nmax
        xvec = xptst (itst) - xori
        yvec = yptst (itst) - yori
        xlen = sqrt (xvec*xvec+yvec*yvec)
        if (xlen < epsilon(1.0)) then
           imin = itst
           xunt1 = xunt
           yunt1 = xunt
           exit
        endif
!
!  Compute distance, weighted by a cosine function of the angle
!  with the last segment. Weight is 1 when straight ahead,
!  3 when going backwards, 2 if transverse. By using some
!  power of the cosine, one may increase or decrease the pressure
!  to go straight ahead with respect to transverse directions.
!
        xang = acos (0.9999*(xvec*xunt+yvec*yunt)/xlen)
        wdst = xlen * (3.0 - 2.0*cos(0.5*xang))
!
!  Retain minimum distance
!
        if (wdst <= wdst0) then
           wdst0 = wdst
           imin = itst
           xunt1 = xvec / xlen
           yunt1 = yvec / xlen
        endif
      enddo
!
!  Exchange retained point with current one
!
      xtmp = xptst (inxt)
      ytmp = yptst (inxt)
      xptst (inxt) = xptst (imin)
      yptst (inxt) = yptst (imin)
      xptst (imin) = xtmp
      yptst (imin) = ytmp
      xunt = xunt1
      yunt = yunt1
   enddo nextpoint 
!
! Output
!
   imax = sum (maxloc(ytmpt))
   do ipnt = 1, nmax
      write (*,*) ipnt,xptst (ipnt), yptst(ipnt), xtmpt (imax), ytmpt (imax)
      imax = mod (imax, nmax) + 1
   enddo 
contains
Subroutine MRGRNK (XVALT, IRNGT)
! __________________________________________________________
!   MRGRNK = Merge-sort ranking of an array
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
      Real, Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
      Real (Kind(XVALT)) :: XVALA, XVALB
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) <= XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Mod(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 2) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XVALT(IRNG1) <= XVALT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B. This line may be activated when the
!   initial set is already close to sorted.
!
!          IF (XVALT(IRNGT(JINDA)) <= XVALT(IRNGT(IINDB))) CYCLE
!
!  One steps in the C subset, that we build in the final rank array
!
!  Make a copy of the rank array for the merge iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
!
            XVALA = XVALT (JWRKT(IINDA))
            XVALB = XVALT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XVALT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XVALT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
      Return
End Subroutine MRGRNK
end Program follow
program givcor
!   Given two arrays of equal length of unordered values, find a 
!   "matching value" in the second array for each value in the
!   first so that the global correlation coefficient reaches
!   exactly a given target.
! _________________________________________________________________
!   The routine first sorts the two arrays, so as to get the 
!   match of maximum correlation. 
!   It then will iterate, applying the random permutation algorithm
!   of controlled disorder ctrper to the second array. When the
!   resulting correlation goes beyond (lower than) the target
!   correlation, one steps back and reduces the disorder parameter
!   of the permutation. When the resulting correlation lies between
!   the current one and the target, one replaces the array with
!   the newly permuted one. When the resulting correlation increases
!   from the current value, one increases the disorder parameter.
!   That way, the target correlation is approached from above, by 
!   a controlled increase in randomness.
!   The example is two arrays representing parents' incomes and
!   children's incomes, but where it is not known which parents
!   correspond to which children. The output is a list of pairs
!   {parents' income, children's income} such that the target
!   correlation is approached.
!   Michel Olagnon - December 2001.
! _________________________________________________________________
      use m_ctrper
      use m_refsor
!
      Integer, Parameter :: ndim = 21571   ! Number of pairs  
      Integer, Parameter :: kdp = selected_real_kind(15)
      Real(kind=kdp), Parameter :: dtar = 0.1654_kdp ! Target correlation
      Real(kind=kdp) :: dsum, dref, dmoyp, dsigp, dmoyc, dsigc
      Real(kind=kdp), Dimension (ndim) :: xpart, xchit, xnewt
      Real :: xper = 0.25
      Real :: xdec = 0.997
      Integer, Dimension (:), Allocatable :: jseet, jsavt
      Integer :: nsee, ibcl
!
      Call random_seed (size=nsee)
      Allocate (jseet(1:nsee), jsavt(1:nsee))
!
!   Read parent's incomes
!
      Open (unit=11, file="parents.dat", form="formatted", status="old", action="read")
      Do ibcl = 1, ndim
        read (unit=11, fmt=*) xpart (ibcl)
      End Do
      Close (unit=11)
!
!   Sort, and normalize to make further correlation computations faster
!
      call refsor (xpart)
      dmoyp = sum (xpart) / real (ndim, kind=kdp)
      xpart = xpart - dmoyp
      dsigp = sqrt(dot_product(xpart,xpart))
      xpart = xpart * (1.0_kdp/dsigp)
!
!   Read children's incomes
!
      Open (unit=12, file="children.dat", form="formatted", status="old", action="read")
      Do ibcl = 1, ndim
        read (unit=12, fmt=*) xchit (ibcl)
      End Do
      Close (unit=12)
!
!   Sort, and normalize
!
      call refsor (xchit)
      dmoyc = sum (xchit) / real (ndim, kind=kdp)
      xchit = xchit - dmoyc
      dsigc = sqrt(dot_product(xchit,xchit))
      xchit = xchit * (1.0_kdp/dsigc)
!
!   Compute starting value, maximum correlation
!
      dref = dot_product(xpart,xchit)
!      write (unit=*, fmt="(f8.6)") dref
!
!   Iterate
!
      Do ibcl = 1, 100000
        xnewt = xchit
!
!   Add some randomness to the current order
!
        Call ctrper (xnewt, xper)
        dsum = dot_product(xnewt,xchit)
!    if (modulo (ibcl,100) == 1) write (unit=*, fmt=*) ibcl, dref, dsum, xper
!
!   Check for hit of target
!
        if (abs (dsum-dtar) < 0.00001_kdp) then
           dref = dsum
           xchit = xnewt           
           exit
        End If
!
!   Better, but not yet reached target: take new set as current one
!
        if (dsum < dref .and. dsum > dtar) then
           dref = dsum
           xchit = xnewt
!
!   We went too far, beyond the target: try to be a little less random
!
        elseif (dsum < dtar) then
           xper = max (xper * xdec, 0.5 / Real(ndim))
!
!   We are going in the ordered direction: try to be a little more random
!
        elseif (dsum > dref) then
           xper = min (xper / xdec, 0.25)
        endif
      End Do
!
!   Unnormalize and output pairs
!
      write (unit=*, fmt="(a,f10.8,a,i8)") "Reached ", dref, &
                                           "after iteration ", ibcl
      xpart = dmoyp + dsigp * xpart
      xchit = dmoyc + dsigc * xchit
      Open (unit=13, file="corchild.dat", form="formatted", status="unknown",&
            action="write")
      Do ibcl = 1, ndim
           write (unit=13, fmt=*) nint(xpart(ibcl)), nint(xchit(ibcl))
      End Do
      Close (unit=13)
!
end program givcor
Module m_indmed
Integer, Parameter :: kdp = selected_real_kind(15)
public :: indmed
private :: kdp
private :: R_indmed, I_indmed, D_indmed
private :: r_med, i_med, d_med
Integer, Allocatable, Dimension(:), Private, Save :: IDONT
interface indmed
  module procedure d_indmed, r_indmed, i_indmed
end interface indmed
contains

Subroutine D_indmed (XDONT, INDMED)
!  Returns index of median value of XDONT.
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Intent (Out) :: INDMED
! __________________________________________________________
      Integer :: IDON
!
      Allocate (IDONT (SIZE(XDONT)))
      Do IDON = 1, SIZE(XDONT)
         IDONT (IDON) = IDON
      End Do
!
      Call d_med (XDONT, IDONT, INDMED)
!
      Deallocate (IDONT)
End Subroutine D_indmed
   Recursive Subroutine d_med (XDATT, IDATT, ires_med)
!  Finds the index of the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDATT
      Integer, Dimension (:), Intent (In) :: IDATT
      Integer, Intent (Out):: ires_med
! __________________________________________________________
!
      Real (kind=kdp), Parameter :: XHUGE = HUGE (XDATT)
      Real (kind=kdp) :: XWRK, XWRK1, XMED7, XMAX, XMIN
!
      Integer, Dimension (7*(((Size (IDATT)+6)/7+6)/7)) :: ISTRT, IENDT, IMEDT
      Integer, Dimension (7*((Size(IDATT)+6)/7)) :: IWRKT
      Integer :: NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, ITMP, IDCR, ICRS, ICRS1, ICRS2, IMAX, IMIN
      Integer :: IWRK, IWRK1, IMED1, IMED7, NDAT
!
      NDAT = Size (IDATT)
      NMED = (NDAT+1) / 2
      IWRKT = IDATT
!
!  If the number of values is small, then use insertion sort
!
     If (NDAT < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDAT
         If (XDATT (IWRKT (1)) < XDATT (IWRKT (IDCR))) Then
            IWRK = IWRKT (1)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (1)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, NDAT - 2
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                XWRK = XWRK1
                IWRK = IWRK1
            Endif
         End Do
         IWRKT (1) = IWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            IDCR = ICRS - 1
            Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         XWRK1 = XDATT (IWRKT (NMED))
         Do ICRS = NMED+1, NDAT
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            If (XWRK < XWRK1) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               IWRKT (IDCR+1) = IWRK
               XWRK1 = XDATT (IWRKT (NMED))
            End If
         End Do
         ires_med = IWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      IMAX = 1
      IMIN = 1
      XMAX = XDATT (IWRKT(IMAX))
      XMIN = XDATT (IWRKT(IMIN))
      DO IDEB = 1, NDAT-6, 7
         IDCR = IDEB + 6
         If (XDATT (IWRKT(IDEB)) < XDATT (IWRKT(IDCR))) Then
            IWRK = IWRKT(IDEB)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT(IDEB)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, 5
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                IWRK = IWRK1
                XWRK = XWRK1
            Endif
         End Do
         IWRKT (IDEB) = IWRK
         If (XWRK < XMIN) Then
             IMIN = IWRK
             XMIN = XWRK
         End If
         Do ICRS = IDEB+1, IDEB+5
            IWRK = IWRKT (ICRS+1)
            XWRK = XDATT (IWRK)
            IDON = IWRKT(ICRS)
            If (XWRK < XDATT(IDON)) Then
               IWRKT (ICRS+1) = IDON
               IDCR = ICRS
               IWRK1 = IWRKT (IDCR-1)
               XWRK1 = XDATT (IWRK1)
               Do
                  If (XWRK >= XWRK1) Exit
                  IWRKT (IDCR) = IWRK1
                  IDCR = IDCR - 1
                  IWRK1 = IWRKT (IDCR-1)
                  XWRK1 = XDATT (IWRK1)
               End Do
               IWRKT (IDCR) = IWRK
            EndIf
         End Do
         If (XWRK > XMAX) Then
             IMAX = IWRK
             XMAX = XWRK
         End If
      End Do
!
!  Add-up alternatively MAX and MIN values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDAT/7)
      NTRI = NDAT
      If (IDEB < NDAT) Then
!
         Do ICRS = IDEB+1, NDAT
            XWRK1 = XDATT (IWRKT (ICRS))
            IF (XWRK1 > XMAX) Then
               IMAX = IWRKT (ICRS)
               XMAX = XWRK1
            End If
            IF (XWRK1 < XMIN) Then
               IMIN = IWRKT (ICRS)
               XMIN = XWRK1
            End If
         End Do
         IWRK1 = IMAX
         Do ICRS = NDAT+1, IDEB+7
               IWRKT (ICRS) = IWRK1
               If (IWRK1 == IMAX) Then
                  IWRK1 = IMIN
               Else
                  NMED = NMED + 1
                  IWRK1 = IMAX
               End If
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            IWRK = IWRKT (ICRS)
            XWRK = XDATT (IWRK)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XDATT (IWRKT(IDCR))) Exit
               IWRKT (IDCR+1) = IWRKT (IDCR)
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IWRKT (IDON + 3)
         End Do
!
!  Find XMED7, the median of the medians
!
         Call d_med (XDATT, IMEDT(1:IDON1), IMED7)
         XMED7 = XDATT (IMED7)
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XDATT (IWRKT (IMED)) > XMED7) Then
                  IMED = IMED - 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                  IMED = IMED + 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XDATT (IWRKT (IMED)) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XDATT (IWRKT (IMED)) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
!
         If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                IWRK1 = IMAX
                XWRK1 = XDATT (IWRK1)
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) < XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT (ICRS1)
                            XWRK1 = XDATT (IWRK1)
                         Else
                           If (ICRS2 < NORD) Then
                              IWRKT (ICRS1) = IWRKT (ICRS)
                              IWRK1 = IWRKT (ICRS1)
                              XWRK1 = XDATT (IWRK1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) >= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT (ICRS1)
                         XWRK1 = XDATT (IWRK1)
                      End Do
                   End If
                End Do
                ires_med = IWRK1
                Return
            Else
                ires_med = IMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XDATT(IWRKT (ICRS)) > XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT(ICRS1)
                            XWRK1 = XDATT(IWRK1)
                         Else
                            If (ICRS2 < NORD) Then
                               IWRKT (ICRS1) = IWRKT (ICRS)
                               IWRK1 = IWRKT(ICRS1)
                               XWRK1 = XDATT(IWRK1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XDATT(IWRKT (ICRS)) <= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         IDCR = ICRS1 - 1
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT(ICRS1)
                         XWRK1 = XDATT(IWRK1)
                      End Do
                   Endif
                End Do
!
                ires_med = IWRK1
                Return
         End If
!
   END Subroutine d_med
!
Subroutine R_indmed (XDONT, INDMED)
!  Returns index of median value of XDONT.
! __________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Intent (Out) :: INDMED
! __________________________________________________________
      Integer :: IDON
!
      Allocate (IDONT (SIZE(XDONT)))
      Do IDON = 1, SIZE(XDONT)
         IDONT (IDON) = IDON
      End Do
!
      Call r_med (XDONT, IDONT, INDMED)
!
      Deallocate (IDONT)
End Subroutine R_indmed
   Recursive Subroutine r_med (XDATT, IDATT, ires_med)
!  Finds the index of the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
      Real, Dimension (:), Intent (In) :: XDATT
      Integer, Dimension (:), Intent (In) :: IDATT
      Integer, Intent (Out) :: ires_med
! __________________________________________________________
!
      Real, Parameter :: XHUGE = HUGE (XDATT)
      Real :: XWRK, XWRK1, XMED7, XMAX, XMIN
!
      Integer, Dimension (7*(((Size (IDATT)+6)/7+6)/7)) :: ISTRT, IENDT, IMEDT
      Integer, Dimension (7*((Size(IDATT)+6)/7)) :: IWRKT
      Integer :: NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, ITMP, IDCR, ICRS, ICRS1, ICRS2, IMAX, IMIN
      Integer :: IWRK, IWRK1, IMED1, IMED7, NDAT
!
      NDAT = Size (IDATT)
      NMED = (NDAT+1) / 2
      IWRKT = IDATT
!
!  If the number of values is small, then use insertion sort
!
     If (NDAT < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDAT
         If (XDATT (IWRKT (1)) < XDATT (IWRKT (IDCR))) Then
            IWRK = IWRKT (1)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (1)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, NDAT - 2
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                XWRK = XWRK1
                IWRK = IWRK1
            Endif
         End Do
         IWRKT (1) = IWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            IDCR = ICRS - 1
            Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         XWRK1 = XDATT (IWRKT (NMED))
         Do ICRS = NMED+1, NDAT
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            If (XWRK < XWRK1) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               IWRKT (IDCR+1) = IWRK
               XWRK1 = XDATT (IWRKT (NMED))
            End If
         End Do
         ires_med = IWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      IMAX = 1
      IMIN = 1
      XMAX = XDATT (IWRKT(IMAX))
      XMIN = XDATT (IWRKT(IMIN))
      DO IDEB = 1, NDAT-6, 7
         IDCR = IDEB + 6
         If (XDATT (IWRKT(IDEB)) < XDATT (IWRKT(IDCR))) Then
            IWRK = IWRKT(IDEB)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT(IDEB)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, 5
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                IWRK = IWRK1
                XWRK = XWRK1
            Endif
         End Do
         IWRKT (IDEB) = IWRK
         If (XWRK < XMIN) Then
             IMIN = IWRK
             XMIN = XWRK
         End If
         Do ICRS = IDEB+1, IDEB+5
            IWRK = IWRKT (ICRS+1)
            XWRK = XDATT (IWRK)
            IDON = IWRKT(ICRS)
            If (XWRK < XDATT(IDON)) Then
               IWRKT (ICRS+1) = IDON
               IDCR = ICRS
               IWRK1 = IWRKT (IDCR-1)
               XWRK1 = XDATT (IWRK1)
               Do
                  If (XWRK >= XWRK1) Exit
                  IWRKT (IDCR) = IWRK1
                  IDCR = IDCR - 1
                  IWRK1 = IWRKT (IDCR-1)
                  XWRK1 = XDATT (IWRK1)
               End Do
               IWRKT (IDCR) = IWRK
            EndIf
         End Do
         If (XWRK > XMAX) Then
             IMAX = IWRK
             XMAX = XWRK
         End If
      End Do
!
!  Add-up alternatively MAX and MIN values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDAT/7)
      NTRI = NDAT
      If (IDEB < NDAT) Then
!
         Do ICRS = IDEB+1, NDAT
            XWRK1 = XDATT (IWRKT (ICRS))
            IF (XWRK1 > XMAX) Then
               IMAX = IWRKT (ICRS)
               XMAX = XWRK1
            End If
            IF (XWRK1 < XMIN) Then
               IMIN = IWRKT (ICRS)
               XMIN = XWRK1
            End If
         End Do
         IWRK1 = IMAX
         Do ICRS = NDAT+1, IDEB+7
               IWRKT (ICRS) = IWRK1
               If (IWRK1 == IMAX) Then
                  IWRK1 = IMIN
               Else
                  NMED = NMED + 1
                  IWRK1 = IMAX
               End If
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            IWRK = IWRKT (ICRS)
            XWRK = XDATT (IWRK)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XDATT (IWRKT(IDCR))) Exit
               IWRKT (IDCR+1) = IWRKT (IDCR)
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IWRKT (IDON + 3)
         End Do
!
!  Find XMED7, the median of the medians
!
         Call r_med (XDATT, IMEDT(1:IDON1), IMED7)
         XMED7 = XDATT (IMED7)
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XDATT (IWRKT (IMED)) > XMED7) Then
                  IMED = IMED - 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                  IMED = IMED + 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XDATT (IWRKT (IMED)) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XDATT (IWRKT (IMED)) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
!
         If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                IWRK1 = IMAX
                XWRK1 = XDATT (IWRK1)
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) < XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT (ICRS1)
                            XWRK1 = XDATT (IWRK1)
                         Else
                           If (ICRS2 < NORD) Then
                              IWRKT (ICRS1) = IWRKT (ICRS)
                              IWRK1 = IWRKT (ICRS1)
                              XWRK1 = XDATT (IWRK1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) >= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT (ICRS1)
                         XWRK1 = XDATT (IWRK1)
                      End Do
                   End If
                End Do
                ires_med = IWRK1
                Return
            Else
                ires_med = IMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XDATT(IWRKT (ICRS)) > XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT(ICRS1)
                            XWRK1 = XDATT(IWRK1)
                         Else
                            If (ICRS2 < NORD) Then
                               IWRKT (ICRS1) = IWRKT (ICRS)
                               IWRK1 = IWRKT(ICRS1)
                               XWRK1 = XDATT(IWRK1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XDATT(IWRKT (ICRS)) <= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         IDCR = ICRS1 - 1
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT(ICRS1)
                         XWRK1 = XDATT(IWRK1)
                      End Do
                   Endif
                End Do
!
                ires_med = IWRK1
                Return
         End If
!
   END Subroutine r_med
Subroutine I_indmed (XDONT, INDMED)
!  Returns index of median value of XDONT.
! __________________________________________________________
      Integer, Dimension (:), Intent (In) :: XDONT
      Integer, Intent (Out) :: INDMED
! __________________________________________________________
      Integer :: IDON
!
      Allocate (IDONT (SIZE(XDONT)))
      Do IDON = 1, SIZE(XDONT)
         IDONT (IDON) = IDON
      End Do
!
      Call i_med (XDONT, IDONT, INDMED)
!
      Deallocate (IDONT)
End Subroutine I_indmed
   Recursive Subroutine i_med (XDATT, IDATT, ires_med)
!  Finds the index of the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
      Integer, Dimension (:), Intent (In) :: XDATT
      Integer, Dimension (:), Intent (In) :: IDATT
      Integer, Intent (Out) :: ires_med
! __________________________________________________________
!
      Integer, Parameter :: XHUGE = HUGE (XDATT)
      Integer :: XWRK, XWRK1, XMED7, XMAX, XMIN
!
      Integer, Dimension (7*(((Size (IDATT)+6)/7+6)/7)) :: ISTRT, IENDT, IMEDT
      Integer, Dimension (7*((Size(IDATT)+6)/7)) :: IWRKT
      Integer :: NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, ITMP, IDCR, ICRS, ICRS1, ICRS2, IMAX, IMIN
      Integer :: IWRK, IWRK1, IMED1, IMED7, NDAT
!
      NDAT = Size (IDATT)
      NMED = (NDAT+1) / 2
      IWRKT = IDATT
!
!  If the number of values is small, then use insertion sort
!
     If (NDAT < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDAT
         If (XDATT (IWRKT (1)) < XDATT (IWRKT (IDCR))) Then
            IWRK = IWRKT (1)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (1)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, NDAT - 2
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                XWRK = XWRK1
                IWRK = IWRK1
            Endif
         End Do
         IWRKT (1) = IWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            IDCR = ICRS - 1
            Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         XWRK1 = XDATT (IWRKT (NMED))
         Do ICRS = NMED+1, NDAT
            XWRK = XDATT (IWRKT (ICRS))
            IWRK = IWRKT (ICRS)
            If (XWRK < XWRK1) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XDATT (IWRKT(IDCR))) Exit
                  IWRKT (IDCR+1) = IWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               IWRKT (IDCR+1) = IWRK
               XWRK1 = XDATT (IWRKT (NMED))
            End If
         End Do
         ires_med = IWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      IMAX = 1
      IMIN = 1
      XMAX = XDATT (IWRKT(IMAX))
      XMIN = XDATT (IWRKT(IMIN))
      DO IDEB = 1, NDAT-6, 7
         IDCR = IDEB + 6
         If (XDATT (IWRKT(IDEB)) < XDATT (IWRKT(IDCR))) Then
            IWRK = IWRKT(IDEB)
         Else
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT(IDEB)
         Endif
         XWRK = XDATT (IWRK)
         Do ITMP = 1, 5
            IDCR = IDCR - 1
            IWRK1 = IWRKT (IDCR)
            XWRK1 = XDATT (IWRK1)
            If (XWRK1 < XWRK) Then
                IWRKT (IDCR) = IWRK
                IWRK = IWRK1
                XWRK = XWRK1
            Endif
         End Do
         IWRKT (IDEB) = IWRK
         If (XWRK < XMIN) Then
             IMIN = IWRK
             XMIN = XWRK
         End If
         Do ICRS = IDEB+1, IDEB+5
            IWRK = IWRKT (ICRS+1)
            XWRK = XDATT (IWRK)
            IDON = IWRKT(ICRS)
            If (XWRK < XDATT(IDON)) Then
               IWRKT (ICRS+1) = IDON
               IDCR = ICRS
               IWRK1 = IWRKT (IDCR-1)
               XWRK1 = XDATT (IWRK1)
               Do
                  If (XWRK >= XWRK1) Exit
                  IWRKT (IDCR) = IWRK1
                  IDCR = IDCR - 1
                  IWRK1 = IWRKT (IDCR-1)
                  XWRK1 = XDATT (IWRK1)
               End Do
               IWRKT (IDCR) = IWRK
            EndIf
         End Do
         If (XWRK > XMAX) Then
             IMAX = IWRK
             XMAX = XWRK
         End If
      End Do
!
!  Add-up alternatively MAX and MIN values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDAT/7)
      NTRI = NDAT
      If (IDEB < NDAT) Then
!
         Do ICRS = IDEB+1, NDAT
            XWRK1 = XDATT (IWRKT (ICRS))
            IF (XWRK1 > XMAX) Then
               IMAX = IWRKT (ICRS)
               XMAX = XWRK1
            End If
            IF (XWRK1 < XMIN) Then
               IMIN = IWRKT (ICRS)
               XMIN = XWRK1
            End If
         End Do
         IWRK1 = IMAX
         Do ICRS = NDAT+1, IDEB+7
               IWRKT (ICRS) = IWRK1
               If (IWRK1 == IMAX) Then
                  IWRK1 = IMIN
               Else
                  NMED = NMED + 1
                  IWRK1 = IMAX
               End If
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            IWRK = IWRKT (ICRS)
            XWRK = XDATT (IWRK)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XDATT (IWRKT(IDCR))) Exit
               IWRKT (IDCR+1) = IWRKT (IDCR)
            End Do
            IWRKT (IDCR+1) = IWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IWRKT (IDON + 3)
         End Do
!
!  Find XMED7, the median of the medians
!
         Call i_med (XDATT, IMEDT(1:IDON1), IMED7)
         XMED7 = XDATT (IMED7)
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XDATT (IWRKT (IMED)) > XMED7) Then
                  IMED = IMED - 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                  IMED = IMED + 2
                  If (XDATT (IWRKT (IMED)) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XDATT (IWRKT (IMED)) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XDATT (IWRKT (IMED)) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XDATT (IWRKT (IMED)) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XDATT (IWRKT (IMED)) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XDATT (IWRKT (IMED1)) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
!
         If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                IWRK1 = IMAX
                XWRK1 = XDATT (IWRK1)
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) < XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT (ICRS1)
                            XWRK1 = XDATT (IWRK1)
                         Else
                           If (ICRS2 < NORD) Then
                              IWRKT (ICRS1) = IWRKT (ICRS)
                              IWRK1 = IWRKT (ICRS1)
                              XWRK1 = XDATT (IWRK1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XDATT (IWRKT (ICRS)) >= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XDATT (IWRKT (IDCR))) Exit
                               IWRKT  (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT (ICRS1)
                         XWRK1 = XDATT (IWRK1)
                      End Do
                   End If
                End Do
                ires_med = IWRK1
                Return
            Else
                ires_med = IMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XDATT(IWRKT (ICRS)) > XWRK1) Then
                            IWRK = IWRKT (ICRS)
                            XWRK = XDATT (IWRK)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                            End Do
                            IWRKT (IDCR+1) = IWRK
                            IWRK1 = IWRKT(ICRS1)
                            XWRK1 = XDATT(IWRK1)
                         Else
                            If (ICRS2 < NORD) Then
                               IWRKT (ICRS1) = IWRKT (ICRS)
                               IWRK1 = IWRKT(ICRS1)
                               XWRK1 = XDATT(IWRK1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XDATT(IWRKT (ICRS)) <= XWRK1) Exit
                         IWRK = IWRKT (ICRS)
                         XWRK = XDATT (IWRK)
                         IDCR = ICRS1 - 1
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XDATT(IWRKT (IDCR))) Exit
                               IWRKT (IDCR+1) = IWRKT (IDCR)
                         End Do
                         IWRKT (IDCR+1) = IWRK
                         IWRK1 = IWRKT(ICRS1)
                         XWRK1 = XDATT(IWRK1)
                      End Do
                   Endif
                End Do
!
                ires_med = IWRK1
                Return
         End If
!
   END Subroutine i_med
end module m_indmed
Module m_indnth
Integer, Parameter :: kdp = selected_real_kind(15)
public :: indnth
private :: kdp
private :: R_indnth, I_indnth, D_indnth
interface indnth
  module procedure d_indnth, r_indnth, i_indnth
end interface indnth
contains

Function D_indnth (XDONT, NORD) Result (INDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer :: INDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (NORD) :: IRNGT
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = NORD
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) INDNTH = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         If (INTH == 4) INDNTH = IHIGT (3)
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(1)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(1)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(1)) + REAL (2*INTH) / REAL (NDON+INTH) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(1)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                ILOW = ILOWT (1)
                XMAX = XDONT (ILOW)
                Do ICRS = 2, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + 0.5 * (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            INDNTH = IHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XDONT (IRNGT(INTH))
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(INTH))
               End If
               ILOW = ILOW + 1
            End Do
!
            INDNTH = IRNGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
               IWRK = ILOWT (1)
               ILOWT (1) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
                  IWRK = ILOWT (1)
                  ILOWT (1) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(INTH)/REAL(JLOW+INTH) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))

!
!  One takes values > XPIV to IHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!

      IWRK1 = ILOWT (1)
      XWRK1 =  XDONT (IWRK1)
      Do ICRS = 1+1, INTH
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         If (XWRK > XWRK1) Then
            XWRK1 = XWRK
            IWRK1 = IWRK
         End If
      End Do
      INDNTH = IWRK1
      Return
!
!
End Function D_indnth

Function R_indnth (XDONT, NORD) Result (INDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer :: INDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (NORD) :: IRNGT
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = NORD
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) INDNTH = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         If (INTH == 4) INDNTH = IHIGT (3)
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(1)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(1)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(1)) + REAL (2*INTH) / REAL (NDON+INTH) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(1)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                ILOW = ILOWT (1)
                XMAX = XDONT (ILOW)
                Do ICRS = 2, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + 0.5 * (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            INDNTH = IHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XDONT (IRNGT(INTH))
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(INTH))
               End If
               ILOW = ILOW + 1
            End Do
!
            INDNTH = IRNGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
               IWRK = ILOWT (1)
               ILOWT (1) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
                  IWRK = ILOWT (1)
                  ILOWT (1) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(INTH)/REAL(JLOW+INTH) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))

!
!  One takes values > XPIV to IHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!

      IWRK1 = ILOWT (1)
      XWRK1 =  XDONT (IWRK1)
      Do ICRS = 1+1, INTH
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         If (XWRK > XWRK1) Then
            XWRK1 = XWRK
            IWRK1 = IWRK
         End If
      End Do
      INDNTH = IWRK1
      Return
!
!
End Function R_indnth
Function I_indnth (XDONT, NORD) Result (INDNTH)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer :: INDNTH
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (NORD) :: IRNGT
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = NORD
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) INDNTH = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) INDNTH = ILOWT (1)
         If (INTH == 2) INDNTH = IHIGT (1)
         If (INTH == 3) INDNTH = IHIGT (2)
         If (INTH == 4) INDNTH = IHIGT (3)
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(1)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(1)) + REAL(2*INTH)/REAL(NDON+INTH) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(1)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(1)) + REAL (2*INTH) / REAL (NDON+INTH) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(1)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                ILOW = ILOWT (1)
                XMAX = XDONT (ILOW)
                Do ICRS = 2, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + 0.5 * (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            INDNTH = IHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XDONT (IRNGT(INTH))
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(INTH))
               End If
               ILOW = ILOW + 1
            End Do
!
            INDNTH = IRNGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
               IWRK = ILOWT (1)
               ILOWT (1) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(1))) Then
                  IWRK = ILOWT (1)
                  ILOWT (1) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(INTH)/REAL(JLOW+INTH) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))

!
!  One takes values > XPIV to IHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!

      IWRK1 = ILOWT (1)
      XWRK1 =  XDONT (IWRK1)
      Do ICRS = 1+1, INTH
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         If (XWRK > XWRK1) Then
            XWRK1 = XWRK
            IWRK1 = IWRK
         End If
      End Do
      INDNTH = IWRK1
      Return
!
!
End Function I_indnth
end module m_indnth
Module m_inspar
Integer, Parameter :: kdp = selected_real_kind(15)
public :: inspar
private :: kdp
private :: R_inspar, I_inspar, D_inspar
interface inspar
  module procedure d_inspar, r_inspar, i_inspar
end interface inspar
contains

Subroutine D_inspar (XDONT, NORD)
!  Sorts partially XDONT, bringing the NORD lowest values at the
!  begining of the array
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      XWRK1 = XDONT (NORD)
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            XDONT (ICRS) = XWRK1
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
            End Do
            XDONT (IDCR+1) = XWRK
            XWRK1 = XDONT (NORD)
         End If
      End Do
!
!
End Subroutine D_inspar

Subroutine R_inspar (XDONT, NORD)
!  Sorts partially XDONT, bringing the NORD lowest values at the
!  begining of the array
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real    :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      XWRK1 = XDONT (NORD)
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            XDONT (ICRS) = XWRK1
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
            End Do
            XDONT (IDCR+1) = XWRK
            XWRK1 = XDONT (NORD)
         End If
      End Do
!
!
End Subroutine R_inspar
Subroutine I_inspar (XDONT, NORD)
!  Sorts partially XDONT, bringing the NORD lowest values at the
!  begining of the array
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (InOut)  :: XDONT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      XWRK1 = XDONT (NORD)
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            XDONT (ICRS) = XWRK1
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
            End Do
            XDONT (IDCR+1) = XWRK
            XWRK1 = XDONT (NORD)
         End If
      End Do
!
!
End Subroutine I_inspar
end module m_inspar
Module m_inssor
Integer, Parameter :: kdp = selected_real_kind(15)
public :: inssor
private :: kdp
private :: R_inssor, I_inssor, D_inssor
interface inssor
  module procedure d_inssor, r_inssor, i_inssor
end interface inssor
contains

Subroutine D_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
!  This subroutine uses insertion sort. It does not use any
!  work array and is faster when XDONT is of very small size
!  (< 20), or already almost sorted, but worst case behavior
!  can happen fairly probably (initially inverse sorted).
!  In many cases, the quicksort or merge sort method is faster.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
      Real (Kind=kdp) :: XWRK, XMIN
!
! __________________________________________________________
!
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine D_inssor

Subroutine R_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
!  This subroutine uses insertion sort. It does not use any
!  work array and is faster when XDONT is of very small size
!  (< 20), or already almost sorted, but worst case behavior
!  can happen fairly probably (initially inverse sorted).
!  In many cases, the quicksort or merge sort method is faster.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
      Real :: XWRK, XMIN
!
! __________________________________________________________
!
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine R_inssor
Subroutine I_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
!  This subroutine uses insertion sort. It does not use any
!  work array and is faster when XDONT is of very small size
!  (< 20), or already almost sorted, but worst case behavior
!  can happen fairly probably (initially inverse sorted).
!  In many cases, the quicksort or merge sort method is faster.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (InOut)  :: XDONT
! __________________________________________________________
      Integer :: XWRK, XMIN
!
! __________________________________________________________
!
      Integer :: ICRS, IDCR, NDON
!
      NDON = Size (XDONT)
!
! We first bring the minimum to the first location in the array.
! That way, we will have a "guard", and when looking for the
! right place to insert a value, no loop test is necessary.
!
      If (XDONT (1) < XDONT (NDON)) Then
          XMIN = XDONT (1)
      Else
          XMIN = XDONT (NDON)
          XDONT (NDON) = XDONT (1)
      Endif
      Do IDCR = NDON-1, 2, -1
         XWRK = XDONT(IDCR)
         IF (XWRK < XMIN) Then
            XDONT (IDCR) = XMIN
            XMIN = XWRK
         End If
      End Do
      XDONT (1) = XMIN
!
! The first value is now the minimum
! Loop over the array, and when a value is smaller than
! the previous one, loop down to insert it at its right place.
!
      Do ICRS = 3, NDON
         XWRK = XDONT (ICRS)
         IDCR = ICRS - 1
         If (XWRK < XDONT(IDCR)) Then
            XDONT (ICRS) = XDONT (IDCR)
            IDCR = IDCR - 1
            Do
               If (XWRK >= XDONT(IDCR)) Exit
               XDONT (IDCR+1) = XDONT (IDCR)
               IDCR = IDCR - 1
            End Do
            XDONT (IDCR+1) = XWRK
         End If
      End Do
!
      Return
!
End Subroutine I_inssor
end module m_inssor
Module m_mrgref
Integer, Parameter :: kdp = selected_real_kind(15)
public :: mrgref
private :: kdp
private :: R_mrgref, I_mrgref, D_mrgref
interface mrgref
  module procedure d_mrgref, r_mrgref, i_mrgref
end interface mrgref
contains

Subroutine D_mrgref (XVALT, IRNGT)
!   Ranks array XVALT into index array IRNGT, using merge-sort
! __________________________________________________________
!   This version is not optimized for performance, and is thus
!   not as difficult to read as some other ones.
!   Michel Olagnon - April 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
!
      Integer, Dimension (:), Allocatable :: JWRKT
      Integer :: LMTNA, LMTNC
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      If (NVAL <= 0) Then
         Return
      End If
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      Allocate (JWRKT(1:NVAL))
      LMTNC = 2
      LMTNA = 2
!
!  Iteration. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
         IWRK = 0
!
!   Loop on merges of A and B into C
!
         Do
            IINDA = IWRKF
            IWRKD = IWRKF + 1
            IWRKF = IINDA + LMTNC
            JINDA = IINDA + LMTNA
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDB = JINDA
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B (no need to do anything)
!
            If (XVALT(IRNGT(JINDA)) <= XVALT(IRNGT(JINDA+1))) Then
               IWRK = IWRKF
               Cycle
            End If
!
!  One steps in the C subset, that we create in the final rank array
!
            Do
               If (IWRK >= IWRKF) Then
!
!  Make a copy of the rank array for next iteration
!
                  IRNGT (IWRKD:IWRKF) = JWRKT (IWRKD:IWRKF)
                  Exit
               End If
!
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (IINDA < JINDA) Then
                  If (IINDB < IWRKF) Then
                     If (XVALT(IRNGT(IINDA+1)) > XVALT(IRNGT(IINDB+1))) &
                    & Then
                        IINDB = IINDB + 1
                        JWRKT (IWRK) = IRNGT (IINDB)
                     Else
                        IINDA = IINDA + 1
                        JWRKT (IWRK) = IRNGT (IINDA)
                     End If
                  Else
!
!  Only A still with unprocessed values
!
                     IINDA = IINDA + 1
                     JWRKT (IWRK) = IRNGT (IINDA)
                  End If
               Else
!
!  Only B still with unprocessed values
!
                  IRNGT (IWRKD:IINDB) = JWRKT (IWRKD:IINDB)
                  IWRK = IWRKF
                  Exit
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!  Clean up
!
      Deallocate (JWRKT)
      Return
!
End Subroutine D_mrgref

Subroutine R_mrgref (XVALT, IRNGT)
!   Ranks array XVALT into index array IRNGT, using merge-sort
! __________________________________________________________
!   This version is not optimized for performance, and is thus
!   not as difficult to read as some other ones.
!   Michel Olagnon - April 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
!
      Integer, Dimension (:), Allocatable :: JWRKT
      Integer :: LMTNA, LMTNC
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      If (NVAL <= 0) Then
         Return
      End If
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      Allocate (JWRKT(1:NVAL))
      LMTNC = 2
      LMTNA = 2
!
!  Iteration. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
         IWRK = 0
!
!   Loop on merges of A and B into C
!
         Do
            IINDA = IWRKF
            IWRKD = IWRKF + 1
            IWRKF = IINDA + LMTNC
            JINDA = IINDA + LMTNA
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDB = JINDA
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B (no need to do anything)
!
            If (XVALT(IRNGT(JINDA)) <= XVALT(IRNGT(JINDA+1))) Then
               IWRK = IWRKF
               Cycle
            End If
!
!  One steps in the C subset, that we create in the final rank array
!
            Do
               If (IWRK >= IWRKF) Then
!
!  Make a copy of the rank array for next iteration
!
                  IRNGT (IWRKD:IWRKF) = JWRKT (IWRKD:IWRKF)
                  Exit
               End If
!
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (IINDA < JINDA) Then
                  If (IINDB < IWRKF) Then
                     If (XVALT(IRNGT(IINDA+1)) > XVALT(IRNGT(IINDB+1))) &
                    & Then
                        IINDB = IINDB + 1
                        JWRKT (IWRK) = IRNGT (IINDB)
                     Else
                        IINDA = IINDA + 1
                        JWRKT (IWRK) = IRNGT (IINDA)
                     End If
                  Else
!
!  Only A still with unprocessed values
!
                     IINDA = IINDA + 1
                     JWRKT (IWRK) = IRNGT (IINDA)
                  End If
               Else
!
!  Only B still with unprocessed values
!
                  IRNGT (IWRKD:IINDB) = JWRKT (IWRKD:IINDB)
                  IWRK = IWRKF
                  Exit
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!  Clean up
!
      Deallocate (JWRKT)
      Return
!
End Subroutine R_mrgref
Subroutine I_mrgref (XVALT, IRNGT)
!   Ranks array XVALT into index array IRNGT, using merge-sort
! __________________________________________________________
!   This version is not optimized for performance, and is thus
!   not as difficult to read as some other ones.
!   Michel Olagnon - April 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
!
      Integer, Dimension (:), Allocatable :: JWRKT
      Integer :: LMTNA, LMTNC
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      If (NVAL <= 0) Then
         Return
      End If
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      Allocate (JWRKT(1:NVAL))
      LMTNC = 2
      LMTNA = 2
!
!  Iteration. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
         IWRK = 0
!
!   Loop on merges of A and B into C
!
         Do
            IINDA = IWRKF
            IWRKD = IWRKF + 1
            IWRKF = IINDA + LMTNC
            JINDA = IINDA + LMTNA
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDB = JINDA
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B (no need to do anything)
!
            If (XVALT(IRNGT(JINDA)) <= XVALT(IRNGT(JINDA+1))) Then
               IWRK = IWRKF
               Cycle
            End If
!
!  One steps in the C subset, that we create in the final rank array
!
            Do
               If (IWRK >= IWRKF) Then
!
!  Make a copy of the rank array for next iteration
!
                  IRNGT (IWRKD:IWRKF) = JWRKT (IWRKD:IWRKF)
                  Exit
               End If
!
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (IINDA < JINDA) Then
                  If (IINDB < IWRKF) Then
                     If (XVALT(IRNGT(IINDA+1)) > XVALT(IRNGT(IINDB+1))) &
                    & Then
                        IINDB = IINDB + 1
                        JWRKT (IWRK) = IRNGT (IINDB)
                     Else
                        IINDA = IINDA + 1
                        JWRKT (IWRK) = IRNGT (IINDA)
                     End If
                  Else
!
!  Only A still with unprocessed values
!
                     IINDA = IINDA + 1
                     JWRKT (IWRK) = IRNGT (IINDA)
                  End If
               Else
!
!  Only B still with unprocessed values
!
                  IRNGT (IWRKD:IINDB) = JWRKT (IWRKD:IINDB)
                  IWRK = IWRKF
                  Exit
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!  Clean up
!
      Deallocate (JWRKT)
      Return
!
End Subroutine I_mrgref
end module m_mrgref
Module m_mrgrnk
Integer, Parameter :: kdp = selected_real_kind(15)
public :: mrgrnk
private :: kdp
private :: R_mrgrnk, I_mrgrnk, D_mrgrnk
interface mrgrnk
  module procedure D_mrgrnk, R_mrgrnk, I_mrgrnk
end interface mrgrnk
contains

Subroutine D_mrgrnk (XDONT, IRNGT)
! __________________________________________________________
!   MRGRNK = Merge-sort ranking of an array
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
      Real (kind=kdp) :: XVALA, XVALB
!
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IRNGT))
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) <= XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 2) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B. This line may be activated when the
!   initial set is already close to sorted.
!
!          IF (XDONT(IRNGT(JINDA)) <= XDONT(IRNGT(IINDB))) CYCLE
!
!  One steps in the C subset, that we build in the final rank array
!
!  Make a copy of the rank array for the merge iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
!
            XVALA = XDONT (JWRKT(IINDA))
            XVALB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
      Return
!
End Subroutine D_mrgrnk

Subroutine R_mrgrnk (XDONT, IRNGT)
! __________________________________________________________
!   MRGRNK = Merge-sort ranking of an array
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
      Real :: XVALA, XVALB
!
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IRNGT))
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) <= XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 2) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B. This line may be activated when the
!   initial set is already close to sorted.
!
!          IF (XDONT(IRNGT(JINDA)) <= XDONT(IRNGT(IINDB))) CYCLE
!
!  One steps in the C subset, that we build in the final rank array
!
!  Make a copy of the rank array for the merge iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
!
            XVALA = XDONT (JWRKT(IINDA))
            XVALB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
      Return
!
End Subroutine R_mrgrnk
Subroutine I_mrgrnk (XDONT, IRNGT)
! __________________________________________________________
!   MRGRNK = Merge-sort ranking of an array
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
      Integer :: XVALA, XVALB
!
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IRNGT))
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) <= XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 2) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B. This line may be activated when the
!   initial set is already close to sorted.
!
!          IF (XDONT(IRNGT(JINDA)) <= XDONT(IRNGT(IINDB))) CYCLE
!
!  One steps in the C subset, that we build in the final rank array
!
!  Make a copy of the rank array for the merge iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
!
            XVALA = XDONT (JWRKT(IINDA))
            XVALB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
      Return
!
End Subroutine I_mrgrnk
end module m_mrgrnk
Module m_mulcnt
Use m_uniinv
Private
Integer, Parameter :: kdp = selected_real_kind(15)
public :: mulcnt
private :: kdp
private :: R_mulcnt, I_mulcnt, D_mulcnt
interface mulcnt
  module procedure d_mulcnt, r_mulcnt, i_mulcnt
end interface mulcnt
contains

Subroutine D_mulcnt (XDONT, IMULT)
!   MULCNT = Give for each array value its multiplicity
!            (number of times that it appears in the array)
! __________________________________________________________
!  Michel Olagnon - Mar. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IMULT
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Integer, Dimension (Size(XDONT)) :: ICNTT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      ICNTT = 0
      Do ICRS = 1, Size(XDONT)
            ICNTT(IWRKT(ICRS)) = ICNTT(IWRKT(ICRS)) + 1
      End Do
      Do ICRS = 1, Size(XDONT)
            IMULT(ICRS) = ICNTT(IWRKT(ICRS))
      End Do

!
End Subroutine D_mulcnt

Subroutine R_mulcnt (XDONT, IMULT)
!   MULCNT = Give for each array value its multiplicity
!            (number of times that it appears in the array)
! __________________________________________________________
!  Michel Olagnon - Mar. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IMULT
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Integer, Dimension (Size(XDONT)) :: ICNTT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      ICNTT = 0
      Do ICRS = 1, Size(XDONT)
            ICNTT(IWRKT(ICRS)) = ICNTT(IWRKT(ICRS)) + 1
      End Do
      Do ICRS = 1, Size(XDONT)
            IMULT(ICRS) = ICNTT(IWRKT(ICRS))
      End Do

!
End Subroutine R_mulcnt
Subroutine I_mulcnt (XDONT, IMULT)
!   MULCNT = Give for each array value its multiplicity
!            (number of times that it appears in the array)
! __________________________________________________________
!  Michel Olagnon - Mar. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IMULT
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Integer, Dimension (Size(XDONT)) :: ICNTT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      ICNTT = 0
      Do ICRS = 1, Size(XDONT)
            ICNTT(IWRKT(ICRS)) = ICNTT(IWRKT(ICRS)) + 1
      End Do
      Do ICRS = 1, Size(XDONT)
            IMULT(ICRS) = ICNTT(IWRKT(ICRS))
      End Do

!
End Subroutine I_mulcnt
end module m_mulcnt
Module m_refpar
Integer, Parameter :: kdp = selected_real_kind(15)
public :: refpar
private :: kdp
private :: R_refpar, I_refpar, D_refpar
interface refpar
  module procedure d_refpar, r_refpar, i_refpar
end interface refpar
contains

Subroutine D_refpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm. It uses
!  a temporary array, where it stores the partially ranked indices
!  of the values. It iterates until it can bring the number of
!  values lower than the pivot to exactly NORD, and then uses an
!  insertion sort to rank this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XPIV, XWRK
! __________________________________________________________
!
      Integer, Dimension (SIZE(XDONT)) :: IWRKT
      Integer :: NDON, ICRS, IDEB, IDCR, IFIN, IMIL, IWRK
!
      NDON = SIZE (XDONT)
!
      Do ICRS = 1, NDON
         IWRKT (ICRS) = ICRS
      End Do
      IDEB = 1
      IFIN = NDON
      Do
         If (IDEB >= IFIN) Exit
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
            IWRK = IWRKT (IDEB)
            IWRKT (IDEB) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
         End If
         If (XDONT(IWRKT(IMIL)) > XDONT(IWRKT(IFIN))) Then
            IWRK = IWRKT (IFIN)
            IWRKT (IFIN) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
            If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
               IWRK = IWRKT (IDEB)
               IWRKT (IDEB) = IWRKT (IMIL)
               IWRKT (IMIL) = IWRK
            End If
         End If
         If ((IFIN-IDEB) < 3) Exit
         XPIV = XDONT (IWRKT(IMIL))
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IWRKT(IDCR)
!  the last   <= pivot is IWRKT(ICRS-1)
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IWRKT(IFIN)) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(IWRKT(ICRS)) > XPIV) Exit
            End Do
            Do
               If (XDONT(IWRKT(IDCR)) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always IWRKT(ICRS-1)
!
                  Exit ECH2
               End If
            End Do
!
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (ICRS)
            IWRKT (ICRS) = IWRK
         End Do ECH2
!
!  One restricts further processing to find the fractile value
!
         If (ICRS <= NORD) IDEB = ICRS
         If (ICRS > NORD) IFIN = ICRS - 1
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      Do ICRS = 2, NORD
         IWRK = IWRKT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK <= XDONT(IWRKT(IDCR))) Then
               IWRKT (IDCR+1) = IWRKT (IDCR)
            Else
               Exit
            End If
         End Do
         IWRKT (IDCR+1) = IWRK
      End Do
      IRNGT (1:NORD) = IWRKT (1:NORD)
      Return
!
End Subroutine D_refpar

Subroutine R_refpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm. It uses
!  a temporary array, where it stores the partially ranked indices
!  of the values. It iterates until it can bring the number of
!  values lower than the pivot to exactly NORD, and then uses an
!  insertion sort to rank this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real :: XPIV, XWRK
! __________________________________________________________
!
      Integer, Dimension (SIZE(XDONT)) :: IWRKT
      Integer :: NDON, ICRS, IDEB, IDCR, IFIN, IMIL, IWRK
!
      NDON = SIZE (XDONT)
!
      Do ICRS = 1, NDON
         IWRKT (ICRS) = ICRS
      End Do
      IDEB = 1
      IFIN = NDON
      Do
         If (IDEB >= IFIN) Exit
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
            IWRK = IWRKT (IDEB)
            IWRKT (IDEB) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
         End If
         If (XDONT(IWRKT(IMIL)) > XDONT(IWRKT(IFIN))) Then
            IWRK = IWRKT (IFIN)
            IWRKT (IFIN) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
            If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
               IWRK = IWRKT (IDEB)
               IWRKT (IDEB) = IWRKT (IMIL)
               IWRKT (IMIL) = IWRK
            End If
         End If
         If ((IFIN-IDEB) < 3) Exit
         XPIV = XDONT (IWRKT(IMIL))
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IWRKT(IDCR)
!  the last   <= pivot is IWRKT(ICRS-1)
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IWRKT(IFIN)) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(IWRKT(ICRS)) > XPIV) Exit
            End Do
            Do
               If (XDONT(IWRKT(IDCR)) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always IWRKT(ICRS-1)
!
                  Exit ECH2
               End If
            End Do
!
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (ICRS)
            IWRKT (ICRS) = IWRK
         End Do ECH2
!
!  One restricts further processing to find the fractile value
!
         If (ICRS <= NORD) IDEB = ICRS
         If (ICRS > NORD) IFIN = ICRS - 1
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      Do ICRS = 2, NORD
         IWRK = IWRKT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK <= XDONT(IWRKT(IDCR))) Then
               IWRKT (IDCR+1) = IWRKT (IDCR)
            Else
               Exit
            End If
         End Do
         IWRKT (IDCR+1) = IWRK
      End Do
      IRNGT (1:NORD) = IWRKT (1:NORD)
      Return
!
End Subroutine R_refpar
Subroutine I_refpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm. It uses
!  a temporary array, where it stores the partially ranked indices
!  of the values. It iterates until it can bring the number of
!  values lower than the pivot to exactly NORD, and then uses an
!  insertion sort to rank this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer :: XPIV, XWRK
!
      Integer, Dimension (SIZE(XDONT)) :: IWRKT
      Integer :: NDON, ICRS, IDEB, IDCR, IFIN, IMIL, IWRK
!
      NDON = SIZE (XDONT)
!
      Do ICRS = 1, NDON
         IWRKT (ICRS) = ICRS
      End Do
      IDEB = 1
      IFIN = NDON
      Do
         If (IDEB >= IFIN) Exit
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
            IWRK = IWRKT (IDEB)
            IWRKT (IDEB) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
         End If
         If (XDONT(IWRKT(IMIL)) > XDONT(IWRKT(IFIN))) Then
            IWRK = IWRKT (IFIN)
            IWRKT (IFIN) = IWRKT (IMIL)
            IWRKT (IMIL) = IWRK
            If (XDONT(IWRKT(IMIL)) < XDONT(IWRKT(IDEB))) Then
               IWRK = IWRKT (IDEB)
               IWRKT (IDEB) = IWRKT (IMIL)
               IWRKT (IMIL) = IWRK
            End If
         End If
         If ((IFIN-IDEB) < 3) Exit
         XPIV = XDONT (IWRKT(IMIL))
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IWRKT(IDCR)
!  the last   <= pivot is IWRKT(ICRS-1)
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IWRKT(IFIN)) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(IWRKT(ICRS)) > XPIV) Exit
            End Do
            Do
               If (XDONT(IWRKT(IDCR)) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always IWRKT(ICRS-1)
!
                  Exit ECH2
               End If
            End Do
!
            IWRK = IWRKT (IDCR)
            IWRKT (IDCR) = IWRKT (ICRS)
            IWRKT (ICRS) = IWRK
         End Do ECH2
!
!  One restricts further processing to find the fractile value
!
         If (ICRS <= NORD) IDEB = ICRS
         If (ICRS > NORD) IFIN = ICRS - 1
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      Do ICRS = 2, NORD
         IWRK = IWRKT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK <= XDONT(IWRKT(IDCR))) Then
               IWRKT (IDCR+1) = IWRKT (IDCR)
            Else
               Exit
            End If
         End Do
         IWRKT (IDCR+1) = IWRK
      End Do
      IRNGT (1:NORD) = IWRKT (1:NORD)
      Return
!
End Subroutine I_refpar
end module m_refpar
Module m_refsor
Integer, Parameter :: kdp = selected_real_kind(15)
public :: refsor
private :: kdp
private :: R_refsor, I_refsor, D_refsor
private :: R_inssor, I_inssor, D_inssor
private :: R_subsor, I_subsor, D_subsor
interface refsor
  module procedure d_refsor, r_refsor, i_refsor
end interface refsor
contains

Subroutine D_refsor (XDONT)
!  Sorts XDONT into ascending order - Quicksort
! __________________________________________________________
!  Quicksort chooses a "pivot" in the set, and explores the
!  array from both ends, looking for a value > pivot with the
!  increasing index, for a value <= pivot with the decreasing
!  index, and swapping them when it has found one of each.
!  The array is then subdivided in 2 ([3]) subsets:
!  { values <= pivot} {pivot} {values > pivot}
!  One then call recursively the program to sort each subset.
!  When the size of the subarray is small enough, one uses an
!  insertion sort that is faster for very small sets.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
!
!
      Call D_subsor (XDONT, 1, Size (XDONT))
      Call D_inssor (XDONT)
      Return
End Subroutine D_refsor
Recursive Subroutine D_subsor (XDONT, IDEB1, IFIN1)
!  Sorts XDONT from IDEB1 to IFIN1
! __________________________________________________________
      Real(kind=kdp), dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (In) :: IDEB1, IFIN1
! __________________________________________________________
      Integer, Parameter :: NINS = 16 ! Max for insertion sort
      Integer :: ICRS, IDEB, IDCR, IFIN, IMIL
      Real(kind=kdp) :: XPIV, XWRK
!
      IDEB = IDEB1
      IFIN = IFIN1
!
!  If we don't have enough values to make it worth while, we leave
!  them unsorted, and the final insertion sort will take care of them
!
      If ((IFIN - IDEB) > NINS) Then
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IMIL) < XDONT(IDEB)) Then
            XWRK = XDONT (IDEB)
            XDONT (IDEB) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
         End If
         If (XDONT(IMIL) > XDONT(IFIN)) Then
            XWRK = XDONT (IFIN)
            XDONT (IFIN) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
            If (XDONT(IMIL) < XDONT(IDEB)) Then
               XWRK = XDONT (IDEB)
               XDONT (IDEB) = XDONT (IMIL)
               XDONT (IMIL) = XWRK
            End If
         End If
         XPIV = XDONT (IMIL)
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IDCR
!  the last   <= pivot is ICRS-1
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IFIN) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(ICRS) > XPIV) Exit
            End Do
            Do
               If (XDONT(IDCR) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always ICRS-1
!
                  Exit ECH2
               End If
            End Do
!
            XWRK = XDONT (IDCR)
            XDONT (IDCR) = XDONT (ICRS)
            XDONT (ICRS) = XWRK
         End Do ECH2
!
!  One now sorts each of the two sub-intervals
!
         Call D_subsor (XDONT, IDEB1, ICRS-1)
         Call D_subsor (XDONT, IDCR, IFIN1)
      End If
      Return
   End Subroutine D_subsor
   Subroutine D_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
      Real(kind=kdp), dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
      Integer :: ICRS, IDCR
      Real(kind=kdp) :: XWRK
!
      Do ICRS = 2, Size (XDONT)
         XWRK = XDONT (ICRS)
         If (XWRK >= XDONT(ICRS-1)) Cycle
         XDONT (ICRS) = XDONT (ICRS-1)
         Do IDCR = ICRS - 2, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      Return
!
End Subroutine D_inssor
!
Subroutine R_refsor (XDONT)
!  Sorts XDONT into ascending order - Quicksort
! __________________________________________________________
!  Quicksort chooses a "pivot" in the set, and explores the
!  array from both ends, looking for a value > pivot with the
!  increasing index, for a value <= pivot with the decreasing
!  index, and swapping them when it has found one of each.
!  The array is then subdivided in 2 ([3]) subsets:
!  { values <= pivot} {pivot} {values > pivot}
!  One then call recursively the program to sort each subset.
!  When the size of the subarray is small enough, one uses an
!  insertion sort that is faster for very small sets.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
!
!
      Call R_subsor (XDONT, 1, Size (XDONT))
      Call R_inssor (XDONT)
      Return
End Subroutine R_refsor
Recursive Subroutine R_subsor (XDONT, IDEB1, IFIN1)
!  Sorts XDONT from IDEB1 to IFIN1
! __________________________________________________________
      Real, dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (In) :: IDEB1, IFIN1
! __________________________________________________________
      Integer, Parameter :: NINS = 16 ! Max for insertion sort
      Integer :: ICRS, IDEB, IDCR, IFIN, IMIL
      Real :: XPIV, XWRK
!
      IDEB = IDEB1
      IFIN = IFIN1
!
!  If we don't have enough values to make it worth while, we leave
!  them unsorted, and the final insertion sort will take care of them
!
      If ((IFIN - IDEB) > NINS) Then
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IMIL) < XDONT(IDEB)) Then
            XWRK = XDONT (IDEB)
            XDONT (IDEB) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
         End If
         If (XDONT(IMIL) > XDONT(IFIN)) Then
            XWRK = XDONT (IFIN)
            XDONT (IFIN) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
            If (XDONT(IMIL) < XDONT(IDEB)) Then
               XWRK = XDONT (IDEB)
               XDONT (IDEB) = XDONT (IMIL)
               XDONT (IMIL) = XWRK
            End If
         End If
         XPIV = XDONT (IMIL)
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IDCR
!  the last   <= pivot is ICRS-1
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IFIN) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(ICRS) > XPIV) Exit
            End Do
            Do
               If (XDONT(IDCR) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always ICRS-1
!
                  Exit ECH2
               End If
            End Do
!
            XWRK = XDONT (IDCR)
            XDONT (IDCR) = XDONT (ICRS)
            XDONT (ICRS) = XWRK
         End Do ECH2
!
!  One now sorts each of the two sub-intervals
!
         Call R_subsor (XDONT, IDEB1, ICRS-1)
         Call R_subsor (XDONT, IDCR, IFIN1)
      End If
      Return
   End Subroutine R_subsor
   Subroutine R_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
      Real, dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
      Integer :: ICRS, IDCR
      Real :: XWRK
!
      Do ICRS = 2, Size (XDONT)
         XWRK = XDONT (ICRS)
         If (XWRK >= XDONT(ICRS-1)) Cycle
         XDONT (ICRS) = XDONT (ICRS-1)
         Do IDCR = ICRS - 2, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      Return
!
End Subroutine R_inssor
!
Subroutine I_refsor (XDONT)
!  Sorts XDONT into ascending order - Quicksort
! __________________________________________________________
!  Quicksort chooses a "pivot" in the set, and explores the
!  array from both ends, looking for a value > pivot with the
!  increasing index, for a value <= pivot with the decreasing
!  index, and swapping them when it has found one of each.
!  The array is then subdivided in 2 ([3]) subsets:
!  { values <= pivot} {pivot} {values > pivot}
!  One then call recursively the program to sort each subset.
!  When the size of the subarray is small enough, one uses an
!  insertion sort that is faster for very small sets.
!  Michel Olagnon - Apr. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (InOut)  :: XDONT
! __________________________________________________________
!
!
      Call I_subsor (XDONT, 1, Size (XDONT))
      Call I_inssor (XDONT)
      Return
End Subroutine I_refsor
Recursive Subroutine I_subsor (XDONT, IDEB1, IFIN1)
!  Sorts XDONT from IDEB1 to IFIN1
! __________________________________________________________
      Integer, dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (In) :: IDEB1, IFIN1
! __________________________________________________________
      Integer, Parameter :: NINS = 16 ! Max for insertion sort
      Integer :: ICRS, IDEB, IDCR, IFIN, IMIL
      Integer :: XPIV, XWRK
!
      IDEB = IDEB1
      IFIN = IFIN1
!
!  If we don't have enough values to make it worth while, we leave
!  them unsorted, and the final insertion sort will take care of them
!
      If ((IFIN - IDEB) > NINS) Then
         IMIL = (IDEB+IFIN) / 2
!
!  One chooses a pivot, median of 1st, last, and middle values
!
         If (XDONT(IMIL) < XDONT(IDEB)) Then
            XWRK = XDONT (IDEB)
            XDONT (IDEB) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
         End If
         If (XDONT(IMIL) > XDONT(IFIN)) Then
            XWRK = XDONT (IFIN)
            XDONT (IFIN) = XDONT (IMIL)
            XDONT (IMIL) = XWRK
            If (XDONT(IMIL) < XDONT(IDEB)) Then
               XWRK = XDONT (IDEB)
               XDONT (IDEB) = XDONT (IMIL)
               XDONT (IMIL) = XWRK
            End If
         End If
         XPIV = XDONT (IMIL)
!
!  One exchanges values to put those > pivot in the end and
!  those <= pivot at the beginning
!
         ICRS = IDEB
         IDCR = IFIN
         ECH2: Do
            Do
               ICRS = ICRS + 1
               If (ICRS >= IDCR) Then
!
!  the first  >  pivot is IDCR
!  the last   <= pivot is ICRS-1
!  Note: If one arrives here on the first iteration, then
!        the pivot is the maximum of the set, the last value is equal
!        to it, and one can reduce by one the size of the set to process,
!        as if XDONT (IFIN) > XPIV
!
                  Exit ECH2
!
               End If
               If (XDONT(ICRS) > XPIV) Exit
            End Do
            Do
               If (XDONT(IDCR) <= XPIV) Exit
               IDCR = IDCR - 1
               If (ICRS >= IDCR) Then
!
!  The last value < pivot is always ICRS-1
!
                  Exit ECH2
               End If
            End Do
!
            XWRK = XDONT (IDCR)
            XDONT (IDCR) = XDONT (ICRS)
            XDONT (ICRS) = XWRK
         End Do ECH2
!
!  One now sorts each of the two sub-intervals
!
         Call I_subsor (XDONT, IDEB1, ICRS-1)
         Call I_subsor (XDONT, IDCR, IFIN1)
      End If
      Return
   End Subroutine I_subsor
   Subroutine I_inssor (XDONT)
!  Sorts XDONT into increasing order (Insertion sort)
! __________________________________________________________
      Integer, dimension (:), Intent (InOut) :: XDONT
! __________________________________________________________
      Integer :: ICRS, IDCR
      Integer :: XWRK
!
      Do ICRS = 2, Size (XDONT)
         XWRK = XDONT (ICRS)
         If (XWRK >= XDONT(ICRS-1)) Cycle
         XDONT (ICRS) = XDONT (ICRS-1)
         Do IDCR = ICRS - 2, 1, - 1
            If (XWRK >= XDONT(IDCR)) Exit
            XDONT (IDCR+1) = XDONT (IDCR)
         End Do
         XDONT (IDCR+1) = XWRK
      End Do
!
      Return
!
End Subroutine I_inssor
!
end module m_refsor
Module m_rinpar
Integer, Parameter :: kdp = selected_real_kind(15)
public :: rinpar
private :: kdp
private :: R_rinpar, I_rinpar, D_rinpar
interface rinpar
  module procedure d_rinpar, r_rinpar, i_rinpar
end interface rinpar
contains

Subroutine D_rinpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD = size (IRNGT)
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      IRNGT (1) = 1
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IRNGT(IDCR))) Exit
            IRNGT (IDCR+1) = IRNGT (IDCR)
         End Do
         IRNGT (IDCR+1) = ICRS
      End Do
!
      XWRK1 = XDONT (IRNGT(NORD))
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IRNGT(IDCR))) Exit
               IRNGT (IDCR+1) = IRNGT (IDCR)
            End Do
            IRNGT (IDCR+1) = ICRS
            XWRK1 = XDONT (IRNGT(NORD))
         End If
      End Do
!
!
End Subroutine D_rinpar

Subroutine R_rinpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD = size (IRNGT)
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real    :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      IRNGT (1) = 1
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IRNGT(IDCR))) Exit
            IRNGT (IDCR+1) = IRNGT (IDCR)
         End Do
         IRNGT (IDCR+1) = ICRS
      End Do
!
      XWRK1 = XDONT (IRNGT(NORD))
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IRNGT(IDCR))) Exit
               IRNGT (IDCR+1) = IRNGT (IDCR)
            End Do
            IRNGT (IDCR+1) = ICRS
            XWRK1 = XDONT (IRNGT(NORD))
         End If
      End Do
!
!
End Subroutine R_rinpar
Subroutine I_rinpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD = size (IRNGT)
! __________________________________________________________
!  This subroutine uses insertion sort, limiting insertion
!  to the first NORD values. It does not use any work array
!  and is faster when NORD is very small (2-5), but worst case
!  behavior can happen fairly probably (initially inverse sorted)
!  In many cases, the refined quicksort method is faster.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer :: XWRK, XWRK1
!
      Integer :: ICRS, IDCR
!
      IRNGT (1) = 1
      Do ICRS = 2, NORD
         XWRK = XDONT (ICRS)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK >= XDONT(IRNGT(IDCR))) Exit
            IRNGT (IDCR+1) = IRNGT (IDCR)
         End Do
         IRNGT (IDCR+1) = ICRS
      End Do
!
      XWRK1 = XDONT (IRNGT(NORD))
      Do ICRS = NORD + 1, SIZE (XDONT)
         If (XDONT(ICRS) < XWRK1) Then
            XWRK = XDONT (ICRS)
            Do IDCR = NORD - 1, 1, - 1
               If (XWRK >= XDONT(IRNGT(IDCR))) Exit
               IRNGT (IDCR+1) = IRNGT (IDCR)
            End Do
            IRNGT (IDCR+1) = ICRS
            XWRK1 = XDONT (IRNGT(NORD))
         End If
      End Do
!
!
End Subroutine I_rinpar
end module m_rinpar
Module m_rnkpar
Integer, Parameter :: kdp = selected_real_kind(15)
public :: rnkpar
private :: kdp
private :: R_rnkpar, I_rnkpar, D_rnkpar
interface rnkpar
  module procedure d_rnkpar, r_rnkpar, i_rnkpar
end interface rnkpar
contains

Subroutine D_rnkpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) IRNGT (1) = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      JHIG = 3
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD.
!
        Select Case (NORD-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (*,*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, NORD
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = NORD
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = NORD - 1, 1, - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do
!
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = (JLOW+IDEB) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
               Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
               Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine D_rnkpar

Subroutine R_rnkpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real    :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) IRNGT (1) = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      JHIG = 3
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD.
!
        Select Case (NORD-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (*,*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, NORD
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = NORD
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = NORD - 1, 1, - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do
!
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = (JLOW+IDEB) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
               Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
               Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine R_rnkpar
Subroutine I_rnkpar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer :: XPIV, XPIV0, XWRK, XWRK1, XMIN, XMAX
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) IRNGT (1) = 1
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         ILOWT (1) = 2
         IHIGT (1) = 1
      Else
         ILOWT (1) = 1
         IHIGT (1) = 2
      End If
!
      If (NDON < 3) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XDONT(IHIGT(1))) Then
         IHIGT (2) = IHIGT (1)
         If (XDONT(3) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = 3
         Else
            IHIGT (1) = 3
         End If
      Else
         IHIGT (2) = 3
      End If
!
      If (NDON < 4) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         IHIGT (3) = IHIGT (2)
         IHIGT (2) = IHIGT (1)
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
         Else
            IHIGT (1) = NDON
         End If
      Else
         IHIGT (3) = NDON
      End If
!
      If (NDON < 5) Then
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      JHIG = 3
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIGT (IHIG) = IHIGT (JHIG)
                JHIG = JHIG - 1
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD.
!
        Select Case (NORD-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (*,*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, NORD
                  JHIG = JHIG + 1
                  ILOWT (ICRS) = IHIGT (JHIG)
               End Do
               JLOW = NORD
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IWRK1
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW >= NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do IDCR = NORD - 1, 1, - 1
                     If (XWRK >= XDONT(IRNGT(IDCR))) Exit
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do
!
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = (JLOW+IDEB) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(1)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
               Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
               Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine I_rnkpar
end module m_rnkpar
Module m_uniinv
Integer, Parameter :: kdp = selected_real_kind(15)
public :: uniinv
private :: kdp
private :: R_uniinv, I_uniinv, D_uniinv
private :: R_nearless, I_nearless, D_nearless, nearless
interface uniinv
  module procedure d_uniinv, r_uniinv, i_uniinv
end interface uniinv
interface nearless
  module procedure D_nearless, R_nearless, I_nearless
end interface nearless
contains

Subroutine D_uniinv (XDONT, IGOEST)
! __________________________________________________________
!   UNIINV = Merge-sort inverse ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it sets indices in IGOEST to the rank
!   of the value in the ordered set with duplicates removed.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IGOEST
! __________________________________________________________
      Real (kind=kdp) :: XTST, XDONA, XDONB
!
! __________________________________________________________
      Integer, Dimension (SIZE(IGOEST)) :: JWRKT, IRNGT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2, NUNI
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IGOEST))
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IGOEST (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) < XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XDONA = XDONT (JWRKT(IINDA))
            XDONB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XDONA > XDONB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XDONB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XDONA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = NEARLESS (Min(XDONT(JWRKT(1)), XDONT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XDONT(JWRKT(IINDA)) > XDONT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XDONT(IRNG) > XTST) Then
            XTST = XDONT (IRNG)
            NUNI = NUNI + 1
         End If
         IGOEST (IRNG) = NUNI
!
      End Do
!
      Return
!
End Subroutine D_uniinv

Subroutine R_uniinv (XDONT, IGOEST)
! __________________________________________________________
!   UNIINV = Merge-sort inverse ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it sets indices in IGOEST to the rank
!   of the value in the ordered set with duplicates removed.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IGOEST
! __________________________________________________________
      Real    :: XTST, XDONA, XDONB
!
! __________________________________________________________
      Integer, Dimension (SIZE(IGOEST)) :: JWRKT, IRNGT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2, NUNI
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IGOEST))
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IGOEST (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) < XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XDONA = XDONT (JWRKT(IINDA))
            XDONB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XDONA > XDONB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XDONB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XDONA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = NEARLESS (Min(XDONT(JWRKT(1)), XDONT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XDONT(JWRKT(IINDA)) > XDONT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XDONT(IRNG) > XTST) Then
            XTST = XDONT (IRNG)
            NUNI = NUNI + 1
         End If
         IGOEST (IRNG) = NUNI
!
      End Do
!
      Return
!
End Subroutine R_uniinv
Subroutine I_uniinv (XDONT, IGOEST)
! __________________________________________________________
!   UNIINV = Merge-sort inverse ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it sets indices in IGOEST to the rank
!   of the value in the ordered set with duplicates removed.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IGOEST
! __________________________________________________________
      Integer :: XTST, XDONA, XDONB
!
! __________________________________________________________
      Integer, Dimension (SIZE(IGOEST)) :: JWRKT, IRNGT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2, NUNI
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IGOEST))
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IGOEST (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) < XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo (NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XDONA = XDONT (JWRKT(IINDA))
            XDONB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XDONA > XDONB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XDONB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XDONA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = NEARLESS (Min(XDONT(JWRKT(1)), XDONT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XDONT(JWRKT(IINDA)) > XDONT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XDONT(IRNG) > XTST) Then
            XTST = XDONT (IRNG)
            NUNI = NUNI + 1
         End If
         IGOEST (IRNG) = NUNI
!
      End Do
!
      Return
!
End Subroutine I_uniinv

Function D_nearless (XVAL) result (D_nl)
!  Nearest value less than given value
! __________________________________________________________
      Real (kind=kdp), Intent (In) :: XVAL
      Real (kind=kdp) :: D_nl
! __________________________________________________________
      D_nl = nearest (XVAL, -1.0_kdp)
      return
!
End Function D_nearless
Function R_nearless (XVAL) result (R_nl)
!  Nearest value less than given value
! __________________________________________________________
      Real, Intent (In) :: XVAL
      Real :: R_nl
! __________________________________________________________
      R_nl = nearest (XVAL, -1.0)
      return
!
End Function R_nearless
Function I_nearless (XVAL) result (I_nl)
!  Nearest value less than given value
! __________________________________________________________
      Integer, Intent (In) :: XVAL
      Integer :: I_nl
! __________________________________________________________
      I_nl = XVAL - 1
      return
!
End Function I_nearless

end module m_uniinv
Module m_unipar
Integer, Parameter :: kdp = selected_real_kind(15)
public :: unipar
private :: kdp
private :: R_unipar, I_unipar, D_unipar
interface unipar
  module procedure d_unipar, r_unipar, i_unipar
end interface unipar
contains

Subroutine D_unipar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD at most,
!  removing duplicate entries
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  quickly as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small. At all times, the
!  NORD first values in ILOWT correspond to distinct values
!  of the input array.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (InOut) :: NORD
! __________________________________________________________
      Real (kind=kdp) :: XPIV, XWRK, XWRK1, XMIN, XMAX, XPIV0
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) Then
            NORD = 1
            IRNGT (1) = 1
         End If
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
     Do ICRS = 2, NDON
        If (XDONT(ICRS) == XDONT(1)) Then
          Cycle
        Else If (XDONT(ICRS) < XDONT(1)) Then
           ILOWT (1) = ICRS
           IHIGT (1) = 1
        Else
           ILOWT (1) = 1
           IHIGT (1) = ICRS
        End If
        Exit
     End Do
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, 2)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      ICRS = ICRS + 1
      JHIG = 1
      If (XDONT(ICRS) < XDONT(IHIGT(1))) Then
         If (XDONT(ICRS) < XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = ICRS
         Else If (XDONT(ICRS) > XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ICRS
         End If
      ElseIf (XDONT(ICRS) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = ICRS
      End If
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
            JHIG = JHIG + 1
         ElseIf (XDONT(NDON) > XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = NDON
            JHIG = JHIG + 1
         End If
      ElseIf (XDONT(NDON) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = NDON
      End If
!
      If (NDON <= ICRS+1) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT, i.e. one more than
!  strictly necessary so as to be able to come out of the
!  case where JLOWT would be NORD distinct values followed
!  by values that are exclusively duplicates of these.
!
!
      If (XDONT(NDON) > XPIV) Then
         lowloop1: Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT(ILOWT(ILOW))) Cycle lowloop1
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop1
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         lowloop2: Do ICRS = ICRS + 1, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT (ILOWT(ILOW))) Cycle lowloop2
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop2
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIG = 0
                Do ICRS = 1, JHIG
                   If (XDONT(IHIGT (ICRS)) /= XMIN) then
                      IHIG = IHIG + 1
                      IHIGT (IHIG ) = IHIGT (ICRS)
                   End If
                End Do
                JHIG = IHIG
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD. In order to make better pivot choices, we
!   decrease NORD if we already know that we don't have that
!   many distinct values as a whole.
!
         IF (JLOW+JHIG < NORD) NORD = JLOW+JHIG
         Select Case (NORD-JLOW)
! ______________________________
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!
!   Not enough values in high part either (too many duplicates)
!
            Case (0)
               NORD = JLOW
!
            Case (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               NORD = JLOW
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               ElseIf (XDONT(IHIGT(1)) == XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  NORD = JLOW
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 1
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               NORD = Min (JLOW, NORD)
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               lowloop3: Do ICRS = 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     Do ILOW = 1, JLOW
                        If (XDONT(IHIGT(ICRS)) == XDONT (ILOWT(ILOW))) &
                            Cycle lowloop3
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW > NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do lowloop3
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
! ______________________________
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
! ______________________________
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
! ______________________________
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            insert1: Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do ILOW = 1, NORD - 1
                     If (XWRK <= XDONT(IRNGT(ILOW))) Then
                        If (XWRK == XDONT(IRNGT(ILOW))) Cycle insert1
                        Exit
                     End If
                  End Do
                  Do IDCR = NORD - 1, ILOW, - 1
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do insert1
!
            Return
!
! ______________________________
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = MIN ((JLOW+IDEB) / 2, NORD)
            IFIN = MIN (JLOW, NORD+1)
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(IDEB)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            IFIN = JLOW
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
              lowloop4: Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop4
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop4
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
              lowloop5: Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop5
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop5
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
! ______________________________
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine D_unipar

Subroutine R_unipar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD at most,
!  removing duplicate entries
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  quickly as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small. At all times, the
!  NORD first values in ILOWT correspond to distinct values
!  of the input array.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (InOut) :: NORD
! __________________________________________________________
      Real    :: XPIV, XWRK, XWRK1, XMIN, XMAX, XPIV0
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) Then
            NORD = 1
            IRNGT (1) = 1
         End If
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
     Do ICRS = 2, NDON
        If (XDONT(ICRS) == XDONT(1)) Then
          Cycle
        Else If (XDONT(ICRS) < XDONT(1)) Then
           ILOWT (1) = ICRS
           IHIGT (1) = 1
        Else
           ILOWT (1) = 1
           IHIGT (1) = ICRS
        End If
        Exit
     End Do
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, 2)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      ICRS = ICRS + 1
      JHIG = 1
      If (XDONT(ICRS) < XDONT(IHIGT(1))) Then
         If (XDONT(ICRS) < XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = ICRS
         Else If (XDONT(ICRS) > XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ICRS
         End If
      ElseIf (XDONT(ICRS) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = ICRS
      End If
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
            JHIG = JHIG + 1
         ElseIf (XDONT(NDON) > XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = NDON
            JHIG = JHIG + 1
         End If
      ElseIf (XDONT(NDON) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = NDON
      End If
!
      If (NDON <= ICRS+1) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT, i.e. one more than
!  strictly necessary so as to be able to come out of the
!  case where JLOWT would be NORD distinct values followed
!  by values that are exclusively duplicates of these.
!
!
      If (XDONT(NDON) > XPIV) Then
         lowloop1: Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT(ILOWT(ILOW))) Cycle lowloop1
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop1
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         lowloop2: Do ICRS = ICRS + 1, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT (ILOWT(ILOW))) Cycle lowloop2
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop2
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIG = 0
                Do ICRS = 1, JHIG
                   If (XDONT(IHIGT (ICRS)) /= XMIN) then
                      IHIG = IHIG + 1
                      IHIGT (IHIG ) = IHIGT (ICRS)
                   End If
                End Do
                JHIG = IHIG
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD. In order to make better pivot choices, we
!   decrease NORD if we already know that we don't have that
!   many distinct values as a whole.
!
         IF (JLOW+JHIG < NORD) NORD = JLOW+JHIG
         Select Case (NORD-JLOW)
! ______________________________
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!
!   Not enough values in high part either (too many duplicates)
!
            Case (0)
               NORD = JLOW
!
            Case (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               NORD = JLOW
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               ElseIf (XDONT(IHIGT(1)) == XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  NORD = JLOW
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 1
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               NORD = Min (JLOW, NORD)
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               lowloop3: Do ICRS = 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     Do ILOW = 1, JLOW
                        If (XDONT(IHIGT(ICRS)) == XDONT (ILOWT(ILOW))) &
                            Cycle lowloop3
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW > NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do lowloop3
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
! ______________________________
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
! ______________________________
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
! ______________________________
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            insert1: Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do ILOW = 1, NORD - 1
                     If (XWRK <= XDONT(IRNGT(ILOW))) Then
                        If (XWRK == XDONT(IRNGT(ILOW))) Cycle insert1
                        Exit
                     End If
                  End Do
                  Do IDCR = NORD - 1, ILOW, - 1
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do insert1
!
            Return
!
! ______________________________
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = MIN ((JLOW+IDEB) / 2, NORD)
            IFIN = MIN (JLOW, NORD+1)
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(IDEB)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            IFIN = JLOW
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
              lowloop4: Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop4
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop4
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
              lowloop5: Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop5
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop5
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
! ______________________________
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine R_unipar
Subroutine I_unipar (XDONT, IRNGT, NORD)
!  Ranks partially XDONT by IRNGT, up to order NORD at most,
!  removing duplicate entries
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  quickly as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then uses an insertion sort to rank
!  this set, since it is supposedly small. At all times, the
!  NORD first values in ILOWT correspond to distinct values
!  of the input array.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (InOut) :: NORD
! __________________________________________________________
      Integer :: XPIV, XWRK, XWRK1, XMIN, XMAX, XPIV0
!
      Integer, Dimension (SIZE(XDONT)) :: ILOWT, IHIGT
      Integer :: NDON, JHIG, JLOW, IHIG, IWRK, IWRK1, IWRK2, IWRK3
      Integer :: IDEB, JDEB, IMIL, IFIN, NWRK, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1
!
      NDON = SIZE (XDONT)
!
!    First loop is used to fill-in ILOWT, IHIGT at the same time
!
      If (NDON < 2) Then
         If (NORD >= 1) Then
            NORD = 1
            IRNGT (1) = 1
         End If
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
     Do ICRS = 2, NDON
        If (XDONT(ICRS) == XDONT(1)) Then
          Cycle
        Else If (XDONT(ICRS) < XDONT(1)) Then
           ILOWT (1) = ICRS
           IHIGT (1) = 1
        Else
           ILOWT (1) = 1
           IHIGT (1) = ICRS
        End If
        Exit
     End Do
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, 2)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         Return
      End If
!
      ICRS = ICRS + 1
      JHIG = 1
      If (XDONT(ICRS) < XDONT(IHIGT(1))) Then
         If (XDONT(ICRS) < XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = ICRS
         Else If (XDONT(ICRS) > XDONT(ILOWT(1))) Then
            JHIG = JHIG + 1
            IHIGT (JHIG) = IHIGT (1)
            IHIGT (1) = ICRS
         End If
      ElseIf (XDONT(ICRS) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = ICRS
      End If
!
      If (NDON <= ICRS) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         Return
      End If
!
      If (XDONT(NDON) < XDONT(IHIGT(1))) Then
         If (XDONT(NDON) < XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = ILOWT (1)
            ILOWT (1) = NDON
            JHIG = JHIG + 1
         ElseIf (XDONT(NDON) > XDONT(ILOWT(1))) Then
            Do IDCR = JHIG, 1, -1
              IHIGT (IDCR+1) = IHIGT (IDCR)
            End Do
            IHIGT (1) = NDON
            JHIG = JHIG + 1
         End If
      ElseIf (XDONT(NDON) > XDONT(IHIGT(1))) Then
         JHIG = JHIG + 1
         IHIGT (JHIG) = NDON
      End If
!
      If (NDON <= ICRS+1) Then
         NORD = Min (NORD, JHIG+1)
         If (NORD >= 1) IRNGT (1) = ILOWT (1)
         If (NORD >= 2) IRNGT (2) = IHIGT (1)
         If (NORD >= 3) IRNGT (3) = IHIGT (2)
         If (NORD >= 4) IRNGT (4) = IHIGT (3)
         Return
      End If
!
      JDEB = 0
      IDEB = JDEB + 1
      JLOW = IDEB
      XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                   (XDONT(IHIGT(3))-XDONT(ILOWT(IDEB)))
      If (XPIV >= XDONT(IHIGT(1))) Then
         XPIV = XDONT (ILOWT(IDEB)) + REAL(2*NORD)/REAL(NDON+NORD) * &
                                      (XDONT(IHIGT(2))-XDONT(ILOWT(IDEB)))
         If (XPIV >= XDONT(IHIGT(1))) &
             XPIV = XDONT (ILOWT(IDEB)) + REAL (2*NORD) / REAL (NDON+NORD) * &
                                          (XDONT(IHIGT(1))-XDONT(ILOWT(IDEB)))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the IHIGT array as soon as we have more
!  than enough values in ILOWT, i.e. one more than
!  strictly necessary so as to be able to come out of the
!  case where JLOWT would be NORD distinct values followed
!  by values that are exclusively duplicates of these.
!
!
      If (XDONT(NDON) > XPIV) Then
         lowloop1: Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT(ILOWT(ILOW))) Cycle lowloop1
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop1
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         lowloop2: Do ICRS = ICRS + 1, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               IHIGT (JHIG) = ICRS
            Else
               Do ILOW = 1, JLOW
                 If (XDONT(ICRS) == XDONT (ILOWT(ILOW))) Cycle lowloop2
               End Do
               JLOW = JLOW + 1
               ILOWT (JLOW) = ICRS
               If (JLOW >= NORD) Exit
            End If
         End Do lowloop2
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = ICRS
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         if (JLOW == NORD) Exit
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to NORD
!
           If (NORD > JLOW) Then
                XMIN = XDONT (IHIGT(1))
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XDONT(IHIGT(ICRS)) < XMIN) Then
                      XMIN = XDONT (IHIGT(ICRS))
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                ILOWT (JLOW) = IHIGT (IHIG)
                IHIG = 0
                Do ICRS = 1, JHIG
                   If (XDONT(IHIGT (ICRS)) /= XMIN) then
                      IHIG = IHIG + 1
                      IHIGT (IHIG ) = IHIGT (ICRS)
                   End If
                End Do
                JHIG = IHIG
             Else
                ILOW = ILOWT (JLOW)
                XMAX = XDONT (ILOW)
                Do ICRS = 1, JLOW
                   If (XDONT(ILOWT(ICRS)) > XMAX) Then
                      IWRK = ILOWT (ICRS)
                      XMAX = XDONT (IWRK)
                      ILOWT (ICRS) = ILOW
                      ILOW = IWRK
                   End If
                End Do
                JLOW = JLOW - 1
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to NORD. In order to make better pivot choices, we
!   decrease NORD if we already know that we don't have that
!   many distinct values as a whole.
!
         IF (JLOW+JHIG < NORD) NORD = JLOW+JHIG
         Select Case (NORD-JLOW)
! ______________________________
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            Select Case (JHIG)
!
!   Not enough values in high part either (too many duplicates)
!
            Case (0)
               NORD = JLOW
!
            Case (1)
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               NORD = JLOW
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XDONT(IHIGT(1)) <= XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
               ElseIf (XDONT(IHIGT(1)) == XDONT(IHIGT(2))) Then
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
                  NORD = JLOW
               Else
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (2)
                  JLOW = JLOW + 1
                  ILOWT (JLOW) = IHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (3)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (3) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
               JHIG = 1
               JLOW = JLOW + 1
               ILOWT (JLOW) = IHIGT (1)
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               JHIG = JHIG + 1
               IF (XDONT(IHIGT(JHIG)) /= XDONT(ILOWT(JLOW))) Then
                 JLOW = JLOW + 1
                 ILOWT (JLOW) = IHIGT (JHIG)
               End If
               NORD = Min (JLOW, NORD)
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               IWRK1 = IHIGT (1)
               IWRK2 = IHIGT (2)
               IWRK3 = IHIGT (IFIN)
               If (XDONT(IWRK2) < XDONT(IWRK1)) Then
                  IHIGT (1) = IWRK2
                  IHIGT (2) = IWRK1
                  IWRK2 = IWRK1
               End If
               If (XDONT(IWRK2) > XDONT(IWRK3)) Then
                  IHIGT (IFIN) = IWRK2
                  IHIGT (2) = IWRK3
                  IWRK2 = IWRK3
                  If (XDONT(IWRK2) < XDONT(IHIGT(1))) Then
                     IHIGT (2) = IHIGT (1)
                     IHIGT (1) = IWRK2
                  End If
               End If
!
               JDEB = JLOW
               NWRK = NORD - JLOW
               IWRK1 = IHIGT (1)
               XPIV = XDONT (IWRK1) + REAL (NWRK) / REAL (NORD+NWRK) * &
                                      (XDONT(IHIGT(IFIN))-XDONT(IWRK1))
!
!  One takes values <= pivot to ILOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               lowloop3: Do ICRS = 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     Do ILOW = 1, JLOW
                        If (XDONT(IHIGT(ICRS)) == XDONT (ILOWT(ILOW))) &
                            Cycle lowloop3
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                     If (JLOW > NORD) Exit
                  Else
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = IHIGT (ICRS)
                  End If
               End Do lowloop3
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(IHIGT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = IHIGT (ICRS)
                  End If
               End Do
           End Select
!
! ______________________________
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XDONT (IHIGT(1))
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XDONT(IHIGT(ICRS)) < XMIN) Then
                  XMIN = XDONT (IHIGT(ICRS))
                  IHIG = ICRS
               End If
            End Do
!
            JLOW = JLOW + 1
            ILOWT (JLOW) = IHIGT (IHIG)
            Exit
!
! ______________________________
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
! ______________________________
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            IRNGT (1) = ILOWT (1)
            Do ICRS = 2, NORD
               IWRK = ILOWT (ICRS)
               XWRK = XDONT (IWRK)
               Do IDCR = ICRS - 1, 1, - 1
                  If (XWRK < XDONT(IRNGT(IDCR))) Then
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               IRNGT (IDCR+1) = IWRK
            End Do
!
            XWRK1 = XDONT (IRNGT(NORD))
            insert1: Do ICRS = NORD + 1, JLOW
               If (XDONT(ILOWT (ICRS)) < XWRK1) Then
                  XWRK = XDONT (ILOWT (ICRS))
                  Do ILOW = 1, NORD - 1
                     If (XWRK <= XDONT(IRNGT(ILOW))) Then
                        If (XWRK == XDONT(IRNGT(ILOW))) Cycle insert1
                        Exit
                     End If
                  End Do
                  Do IDCR = NORD - 1, ILOW, - 1
                     IRNGT (IDCR+1) = IRNGT (IDCR)
                  End Do
                  IRNGT (IDCR+1) = ILOWT (ICRS)
                  XWRK1 = XDONT (IRNGT(NORD))
               End If
            End Do insert1
!
            Return
!
! ______________________________
!
         Case (:-6)
!
! last case: too many values in low part
!
            IDEB = JDEB + 1
            IMIL = MIN ((JLOW+IDEB) / 2, NORD)
            IFIN = MIN (JLOW, NORD+1)
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
               IWRK = ILOWT (IDEB)
               ILOWT (IDEB) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
            End If
            If (XDONT(ILOWT(IMIL)) > XDONT(ILOWT(IFIN))) Then
               IWRK = ILOWT (IFIN)
               ILOWT (IFIN) = ILOWT (IMIL)
               ILOWT (IMIL) = IWRK
               If (XDONT(ILOWT(IMIL)) < XDONT(ILOWT(IDEB))) Then
                  IWRK = ILOWT (IDEB)
                  ILOWT (IDEB) = ILOWT (IMIL)
                  ILOWT (IMIL) = IWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XDONT (ILOWT(IDEB)) + REAL(NORD)/REAL(JLOW+NORD) * &
                                      (XDONT(ILOWT(IFIN))-XDONT(ILOWT(1)))
            If (JDEB > 0) Then
               If (XPIV <= XPIV0) &
                   XPIV = XPIV0 + REAL(2*NORD-JDEB)/REAL (JLOW+NORD) * &
                                  (XDONT(ILOWT(IFIN))-XPIV0)
            Else
               IDEB = 1
            End If
!
!  One takes values > XPIV to IHIGT
!  However, we do not process the first values if we have been
!  through the case when we did not have enough low values
!
            JHIG = 0
            IFIN = JLOW
            JLOW = JDEB
!
            If (XDONT(ILOWT(IFIN)) > XPIV) Then
               ICRS = JDEB
              lowloop4: Do
                 ICRS = ICRS + 1
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop4
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop4
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                        JLOW = JLOW + 1
                        ILOWT (JLOW) = ILOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
           Else
              lowloop5: Do ICRS = IDEB, IFIN
                  If (XDONT(ILOWT(ICRS)) > XPIV) Then
                     JHIG = JHIG + 1
                     IHIGT (JHIG) = ILOWT (ICRS)
                  Else
                     XWRK1 = XDONT(ILOWT(ICRS))
                     Do ILOW = IDEB, JLOW
                        If (XWRK1 == XDONT(ILOWT(ILOW))) &
                            Cycle lowloop5
                     End Do
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                     If (JLOW >= NORD) Exit
                  End If
               End Do lowloop5
!
               Do ICRS = ICRS + 1, IFIN
                  If (XDONT(ILOWT(ICRS)) <= XPIV) Then
                     JLOW = JLOW + 1
                     ILOWT (JLOW) = ILOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
! ______________________________
!
      End Do
!
!  Now, we only need to complete ranking of the 1:NORD set
!  Assuming NORD is small, we use a simple insertion sort
!
      IRNGT (1) = ILOWT (1)
      Do ICRS = 2, NORD
         IWRK = ILOWT (ICRS)
         XWRK = XDONT (IWRK)
         Do IDCR = ICRS - 1, 1, - 1
            If (XWRK < XDONT(IRNGT(IDCR))) Then
               IRNGT (IDCR+1) = IRNGT (IDCR)
            Else
               Exit
            End If
         End Do
         IRNGT (IDCR+1) = IWRK
      End Do
     Return
!
!
End Subroutine I_unipar
end module m_unipar
Module m_unirnk
Integer, Parameter :: kdp = selected_real_kind(15)
public :: unirnk
private :: kdp
private :: R_unirnk, I_unirnk, D_unirnk
private :: R_nearless, I_nearless, D_nearless, nearless
interface unirnk
  module procedure D_unirnk, R_unirnk, I_unirnk
end interface unirnk
interface nearless
  module procedure D_nearless, R_nearless, I_nearless
end interface nearless

contains

Subroutine D_unirnk (XVALT, IRNGT, NUNI)
! __________________________________________________________
!   UNIRNK = Merge-sort ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it discards indices that correspond to
!   duplicate entries.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Real (Kind=kdp), Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
      Real (Kind=kdp) :: XTST, XVALA, XVALB
!
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      NUNI = NVAL
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XVALT(IRNG1) <= XVALT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XVALA = XVALT (JWRKT(IINDA))
            XVALB = XVALT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XVALT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XVALT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = Nearless (Min(XVALT(JWRKT(1)), XVALT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XVALT(JWRKT(IINDA)) > XVALT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XVALT(IRNG) > XTST) Then
            XTST = XVALT (IRNG)
            NUNI = NUNI + 1
            IRNGT (NUNI) = IRNG
         End If
!
      End Do
!
      Return
!
End Subroutine D_unirnk

Subroutine R_unirnk (XVALT, IRNGT, NUNI)
! __________________________________________________________
!   UNIRNK = Merge-sort ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it discards indices that correspond to
!   duplicate entries.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Real, Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
      Real :: XTST, XVALA, XVALB
!
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      NUNI = NVAL
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XVALT(IRNG1) <= XVALT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XVALA = XVALT (JWRKT(IINDA))
            XVALB = XVALT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XVALT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XVALT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = Nearless (Min(XVALT(JWRKT(1)), XVALT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XVALT(JWRKT(IINDA)) > XVALT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XVALT(IRNG) > XTST) Then
            XTST = XVALT (IRNG)
            NUNI = NUNI + 1
            IRNGT (NUNI) = IRNG
         End If
!
      End Do
!
      Return
!
End Subroutine R_unirnk
Subroutine I_unirnk (XVALT, IRNGT, NUNI)
! __________________________________________________________
!   UNIRNK = Merge-sort ranking of an array, with removal of
!   duplicate entries.
!   The routine is similar to pure merge-sort ranking, but on
!   the last pass, it discards indices that correspond to
!   duplicate entries.
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In) :: XVALT
      Integer, Dimension (:), Intent (Out) :: IRNGT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
      Integer :: XTST, XVALA, XVALB
!
!
      NVAL = Min (SIZE(XVALT), SIZE(IRNGT))
      NUNI = NVAL
!
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XVALT(IIND-1) < XVALT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 4) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XVALT(IRNGT(IWRKD+2)) <= XVALT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XVALT(IRNGT(IWRKD+1)) <= XVALT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XVALT(IRNG1) <= XVALT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XVALT(IRNG2) <= XVALT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (2*LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!  One steps in the C subset, that we create in the final rank array
!
!  Make a copy of the rank array for the iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
            XVALA = XVALT (JWRKT(IINDA))
            XVALB = XVALT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XVALT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XVALT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
!   Last merge of A and B into C, with removal of duplicates.
!
      IINDA = 1
      IINDB = LMTNA + 1
      NUNI = 0
!
!  One steps in the C subset, that we create in the final rank array
!
      JWRKT (1:LMTNA) = IRNGT (1:LMTNA)
      XTST = Nearless (Min(XVALT(JWRKT(1)), XVALT(IRNGT(IINDB))))
      Do IWRK = 1, NVAL
!
!  We still have unprocessed values in both A and B
!
         If (IINDA <= LMTNA) Then
            If (IINDB <= NVAL) Then
               If (XVALT(JWRKT(IINDA)) > XVALT(IRNGT(IINDB))) Then
                  IRNG = IRNGT (IINDB)
                  IINDB = IINDB + 1
               Else
                  IRNG = JWRKT (IINDA)
                  IINDA = IINDA + 1
               End If
            Else
!
!  Only A still with unprocessed values
!
               IRNG = JWRKT (IINDA)
               IINDA = IINDA + 1
            End If
         Else
!
!  Only B still with unprocessed values
!
            IRNG = IRNGT (IWRK)
         End If
         If (XVALT(IRNG) > XTST) Then
            XTST = XVALT (IRNG)
            NUNI = NUNI + 1
            IRNGT (NUNI) = IRNG
         End If
!
      End Do
!
      Return
!
End Subroutine I_unirnk

Function D_nearless (XVAL) result (D_nl)
!  Nearest value less than given value
! __________________________________________________________
      Real (kind=kdp), Intent (In) :: XVAL
      Real (kind=kdp) :: D_nl
! __________________________________________________________
      D_nl = nearest (XVAL, -1.0_kdp)
      return
!
End Function D_nearless
Function R_nearless (XVAL) result (R_nl)
!  Nearest value less than given value
! __________________________________________________________
      Real, Intent (In) :: XVAL
      Real :: R_nl
! __________________________________________________________
      R_nl = nearest (XVAL, -1.0)
      return
!
End Function R_nearless
Function I_nearless (XVAL) result (I_nl)
!  Nearest value less than given value
! __________________________________________________________
      Integer, Intent (In) :: XVAL
      Integer :: I_nl
! __________________________________________________________
      I_nl = XVAL - 1
      return
!
End Function I_nearless

end module m_unirnk
Module m_unista
Use m_uniinv
Private
Integer, Parameter :: kdp = selected_real_kind(15)
public :: unista
private :: kdp
private :: R_unista, I_unista, D_unista
interface unista
  module procedure d_unista, r_unista, i_unista
end interface unista
contains

Subroutine D_unista (XDONT, NUNI)
!   UNISTA = (Stable unique) Removes duplicates from an array,
!            leaving unique entries in the order of their first
!            appearance in the initial set.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Logical, Dimension (Size(XDONT)) :: IFMPTYT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      IFMPTYT = .True.
      NUNI = 0
      Do ICRS = 1, Size(XDONT)
         If (IFMPTYT(IWRKT(ICRS))) Then
            IFMPTYT(IWRKT(ICRS)) = .False.
            NUNI = NUNI + 1
            XDONT (NUNI) = XDONT (ICRS)
         End If
      End Do
      Return
!
End Subroutine D_unista

Subroutine R_unista (XDONT, NUNI)
!   UNISTA = (Stable unique) Removes duplicates from an array,
!            leaving unique entries in the order of their first
!            appearance in the initial set.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (InOut) :: XDONT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Logical, Dimension (Size(XDONT)) :: IFMPTYT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      IFMPTYT = .True.
      NUNI = 0
      Do ICRS = 1, Size(XDONT)
         If (IFMPTYT(IWRKT(ICRS))) Then
            IFMPTYT(IWRKT(ICRS)) = .False.
            NUNI = NUNI + 1
            XDONT (NUNI) = XDONT (ICRS)
         End If
      End Do
      Return
!
End Subroutine R_unista
Subroutine I_unista (XDONT, NUNI)
!   UNISTA = (Stable unique) Removes duplicates from an array,
!            leaving unique entries in the order of their first
!            appearance in the initial set.
!  Michel Olagnon - Feb. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (InOut)  :: XDONT
      Integer, Intent (Out) :: NUNI
! __________________________________________________________
!
      Integer, Dimension (Size(XDONT)) :: IWRKT
      Logical, Dimension (Size(XDONT)) :: IFMPTYT
      Integer :: ICRS
! __________________________________________________________
      Call UNIINV (XDONT, IWRKT)
      IFMPTYT = .True.
      NUNI = 0
      Do ICRS = 1, Size(XDONT)
         If (IFMPTYT(IWRKT(ICRS))) Then
            IFMPTYT(IWRKT(ICRS)) = .False.
            NUNI = NUNI + 1
            XDONT (NUNI) = XDONT (ICRS)
         End If
      End Do
      Return
!
End Subroutine I_unista
end module m_unista
Module m_valmed
Integer, Parameter :: kdp = selected_real_kind(15)
public :: valmed
private :: kdp
private :: R_valmed, I_valmed, D_valmed
interface valmed
  module procedure d_valmed, r_valmed, i_valmed
end interface valmed
contains

Recursive Function D_valmed (XDONT) Result (res_med)
!  Finds the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
! __________________________________________________________
      Real (kind=kdp), Dimension (:), Intent (In) :: XDONT
      Real (kind=kdp) :: res_med
! __________________________________________________________
      Real (kind=kdp), Parameter :: XHUGE = HUGE (XDONT)
      Real (kind=kdp), Dimension (SIZE(XDONT)+6) :: XWRKT
      Real (kind=kdp) :: XWRK, XWRK1, XMED7
!
      Integer, Dimension ((SIZE(XDONT)+6)/7) :: ISTRT, IENDT, IMEDT
      Integer :: NDON, NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, IWRK, IDCR, ICRS, ICRS1, ICRS2, IMED1
!
      NDON = SIZE (XDONT)
      NMED = (NDON+1) / 2
!      write(unit=*,fmt=*) NMED, NDON
!
!  If the number of values is small, then use insertion sort
!
      If (NDON < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDON
         If (XDONT (1) < XDONT (NDON)) Then
            XWRK = XDONT (1)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (1)
         Endif
         Do IWRK = 1, NDON - 2
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (1) = XWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XWRKT (ICRS)
               IDCR = ICRS - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         Do ICRS = NMED+1, NDON
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT (NMED)) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               XWRKT (IDCR+1) = XWRK
            End If
         End Do
         res_med = XWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      DO IDEB = 1, NDON-6, 7
         IDCR = IDEB + 6
         If (XDONT (IDEB) < XDONT (IDCR)) Then
            XWRK = XDONT (IDEB)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (IDEB)
         Endif
         Do IWRK = 1, 5
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (IDEB) = XWRK
         Do ICRS = IDEB+2, IDEB+6
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT(ICRS-1)) Then
               XWRKT (ICRS) = XWRKT (ICRS-1)
               IDCR = ICRS - 1
               XWRK1 = XWRKT (IDCR-1)
               Do
                  If (XWRK >= XWRK1) Exit
                  XWRKT (IDCR) = XWRK1
                  IDCR = IDCR - 1
                  XWRK1 = XWRKT (IDCR-1)
               End Do
               XWRKT (IDCR) = XWRK
            EndIf
         End Do
      End Do
!
!  Add-up alternatively + and - HUGE values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDON/7)
      NTRI = NDON
      If (IDEB < NDON) Then
!
         XWRK1 = XHUGE
         Do ICRS = IDEB+1, IDEB+7
            If (ICRS <= NDON) Then
               XWRKT (ICRS) = XDONT (ICRS)
            Else
               If (XWRK1 /= XHUGE) NMED = NMED + 1
               XWRKT (ICRS) = XWRK1
               XWRK1 = - XWRK1
            Endif
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            XWRK = XWRKT (ICRS)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IDON + 3
         End Do
!
!  Find XMED7, the median of the medians
!
         XMED7 = D_valmed (XWRKT (IMEDT))
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XWRKT (IMED) > XMED7) Then
                  IMED = IMED - 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XWRKT (IMED) < XMED7) Then
                  IMED = IMED + 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XWRKT (IMED) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XWRKT (IMED) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XWRKT (IMED) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
        If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                XWRK1 = XHUGE
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
               Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) < XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                           If (ICRS2 < NORD) Then
                              XWRKT (ICRS1) = XWRKT (ICRS)
                              XWRK1 = XWRKT(ICRS1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) >= XWRK1) Exit
                         XWRK = XWRKT (ICRS)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                         End Do
                         XWRKT (IDCR+1) = XWRK
                         XWRK1 = XWRKT(ICRS1)
                      End Do
                   End If
                End Do
                res_med = XWRK1
                Return
            Else
                res_med = XMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            If (ICRS2 < NORD) Then
                               XWRKT (ICRS1) = XWRKT (ICRS)
                               XWRK1 = XWRKT (ICRS1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            Exit
                         End If
                      End Do
                   Endif
                End Do
!
                res_med = XWRK1
                Return
         End If
!
End Function D_valmed

Recursive Function R_valmed (XDONT) Result (res_med)
!  Finds the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Real :: res_med
! __________________________________________________________
      Real, Parameter :: XHUGE = HUGE (XDONT)
      Real, Dimension (SIZE(XDONT)+6) :: XWRKT
      Real :: XWRK, XWRK1, XMED7
!
      Integer, Dimension ((SIZE(XDONT)+6)/7) :: ISTRT, IENDT, IMEDT
      Integer :: NDON, NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, IWRK, IDCR, ICRS, ICRS1, ICRS2, IMED1
!
      NDON = SIZE (XDONT)
      NMED = (NDON+1) / 2
!      write(unit=*,fmt=*) NMED, NDON
!
!  If the number of values is small, then use insertion sort
!
      If (NDON < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDON
         If (XDONT (1) < XDONT (NDON)) Then
            XWRK = XDONT (1)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (1)
         Endif
         Do IWRK = 1, NDON - 2
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (1) = XWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XWRKT (ICRS)
               IDCR = ICRS - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         Do ICRS = NMED+1, NDON
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT (NMED)) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               XWRKT (IDCR+1) = XWRK
            End If
         End Do
         res_med = XWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      DO IDEB = 1, NDON-6, 7
         IDCR = IDEB + 6
         If (XDONT (IDEB) < XDONT (IDCR)) Then
            XWRK = XDONT (IDEB)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (IDEB)
         Endif
         Do IWRK = 1, 5
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (IDEB) = XWRK
         Do ICRS = IDEB+2, IDEB+6
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT(ICRS-1)) Then
               XWRKT (ICRS) = XWRKT (ICRS-1)
               IDCR = ICRS - 1
               XWRK1 = XWRKT (IDCR-1)
               Do
                  If (XWRK >= XWRK1) Exit
                  XWRKT (IDCR) = XWRK1
                  IDCR = IDCR - 1
                  XWRK1 = XWRKT (IDCR-1)
               End Do
               XWRKT (IDCR) = XWRK
            EndIf
         End Do
      End Do
!
!  Add-up alternatively + and - HUGE values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDON/7)
      NTRI = NDON
      If (IDEB < NDON) Then
!
         XWRK1 = XHUGE
         Do ICRS = IDEB+1, IDEB+7
            If (ICRS <= NDON) Then
               XWRKT (ICRS) = XDONT (ICRS)
            Else
               If (XWRK1 /= XHUGE) NMED = NMED + 1
               XWRKT (ICRS) = XWRK1
               XWRK1 = - XWRK1
            Endif
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            XWRK = XWRKT (ICRS)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IDON + 3
         End Do
!
!  Find XMED7, the median of the medians
!
         XMED7 = R_valmed (XWRKT (IMEDT))
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XWRKT (IMED) > XMED7) Then
                  IMED = IMED - 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XWRKT (IMED) < XMED7) Then
                  IMED = IMED + 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XWRKT (IMED) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XWRKT (IMED) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XWRKT (IMED) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
        If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                XWRK1 = XHUGE
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
               Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) < XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                           If (ICRS2 < NORD) Then
                              XWRKT (ICRS1) = XWRKT (ICRS)
                              XWRK1 = XWRKT(ICRS1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) >= XWRK1) Exit
                         XWRK = XWRKT (ICRS)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                         End Do
                         XWRKT (IDCR+1) = XWRK
                         XWRK1 = XWRKT(ICRS1)
                      End Do
                   End If
                End Do
                res_med = XWRK1
                Return
            Else
                res_med = XMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            If (ICRS2 < NORD) Then
                               XWRKT (ICRS1) = XWRKT (ICRS)
                               XWRK1 = XWRKT (ICRS1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            Exit
                         End If
                      End Do
                   Endif
                End Do
!
                res_med = XWRK1
                Return
         End If
!
End Function R_valmed
Recursive Function I_valmed (XDONT) Result (res_med)
!  Finds the median of XDONT using the recursive procedure
!  described in Knuth, The Art of Computer Programming,
!  vol. 3, 5.3.3 - This procedure is linear in time, and
!  does not require to be able to interpolate in the
!  set as the one used in INDNTH. It also has better worst
!  case behavior than INDNTH, but is about 30% slower in
!  average for random uniformly distributed values.
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In)  :: XDONT
      Integer :: res_med
! __________________________________________________________
      Integer, Parameter :: XHUGE = HUGE (XDONT)
      Integer, Dimension (SIZE(XDONT)+6) :: XWRKT
      Integer :: XWRK, XWRK1, XMED7
!
      Integer, Dimension ((SIZE(XDONT)+6)/7) :: ISTRT, IENDT, IMEDT
      Integer :: NDON, NTRI, NMED, NORD, NEQU, NLEQ, IMED, IDON, IDON1
      Integer :: IDEB, IWRK, IDCR, ICRS, ICRS1, ICRS2, IMED1
!
      NDON = SIZE (XDONT)
      NMED = (NDON+1) / 2
!      write(unit=*,fmt=*) NMED, NDON
!
!  If the number of values is small, then use insertion sort
!
      If (NDON < 35) Then
!
!  Bring minimum to first location to save test in decreasing loop
!
         IDCR = NDON
         If (XDONT (1) < XDONT (NDON)) Then
            XWRK = XDONT (1)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (1)
         Endif
         Do IWRK = 1, NDON - 2
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (1) = XWRK
!
! Sort the first half, until we have NMED sorted values
!
         Do ICRS = 3, NMED
            XWRK = XWRKT (ICRS)
               IDCR = ICRS - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
!  Insert any value less than the current median in the first half
!
         Do ICRS = NMED+1, NDON
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT (NMED)) Then
               IDCR = NMED - 1
               Do
                  If (XWRK >= XWRKT(IDCR)) Exit
                  XWRKT (IDCR+1) = XWRKT (IDCR)
                  IDCR = IDCR - 1
               End Do
               XWRKT (IDCR+1) = XWRK
            End If
         End Do
         res_med = XWRKT (NMED)
         Return
      End If
!
!  Make sorted subsets of 7 elements
!  This is done by a variant of insertion sort where a first
!  pass is used to bring the smallest element to the first position
!  decreasing disorder at the same time, so that we may remove
!  remove the loop test in the insertion loop.
!
      DO IDEB = 1, NDON-6, 7
         IDCR = IDEB + 6
         If (XDONT (IDEB) < XDONT (IDCR)) Then
            XWRK = XDONT (IDEB)
            XWRKT (IDCR) = XDONT (IDCR)
         Else
            XWRK = XDONT (IDCR)
            XWRKT (IDCR) = XDONT (IDEB)
         Endif
         Do IWRK = 1, 5
            IDCR = IDCR - 1
            XWRK1 = XDONT (IDCR)
            If (XWRK1 < XWRK) Then
                XWRKT (IDCR) = XWRK
                XWRK = XWRK1
            Else
                XWRKT (IDCR) = XWRK1
            Endif
         End Do
         XWRKT (IDEB) = XWRK
         Do ICRS = IDEB+2, IDEB+6
            XWRK = XWRKT (ICRS)
            If (XWRK < XWRKT(ICRS-1)) Then
               XWRKT (ICRS) = XWRKT (ICRS-1)
               IDCR = ICRS - 1
               XWRK1 = XWRKT (IDCR-1)
               Do
                  If (XWRK >= XWRK1) Exit
                  XWRKT (IDCR) = XWRK1
                  IDCR = IDCR - 1
                  XWRK1 = XWRKT (IDCR-1)
               End Do
               XWRKT (IDCR) = XWRK
            EndIf
         End Do
      End Do
!
!  Add-up alternatively + and - HUGE values to make the number of data
!  an exact multiple of 7.
!
      IDEB = 7 * (NDON/7)
      NTRI = NDON
      If (IDEB < NDON) Then
!
         XWRK1 = XHUGE
         Do ICRS = IDEB+1, IDEB+7
            If (ICRS <= NDON) Then
               XWRKT (ICRS) = XDONT (ICRS)
            Else
               If (XWRK1 /= XHUGE) NMED = NMED + 1
               XWRKT (ICRS) = XWRK1
               XWRK1 = - XWRK1
            Endif
         End Do
!
         Do ICRS = IDEB+2, IDEB+7
            XWRK = XWRKT (ICRS)
            Do IDCR = ICRS - 1, IDEB+1, - 1
               If (XWRK >= XWRKT(IDCR)) Exit
               XWRKT (IDCR+1) = XWRKT (IDCR)
            End Do
            XWRKT (IDCR+1) = XWRK
         End Do
!
         NTRI = IDEB+7
      End If
!
!  Make the set of the indices of median values of each sorted subset
!
         IDON1 = 0
         Do IDON = 1, NTRI, 7
            IDON1 = IDON1 + 1
            IMEDT (IDON1) = IDON + 3
         End Do
!
!  Find XMED7, the median of the medians
!
         XMED7 = I_valmed (XWRKT (IMEDT))
!
!  Count how many values are not higher than (and how many equal to) XMED7
!  This number is at least 4 * 1/2 * (N/7) : 4 values in each of the
!  subsets where the median is lower than the median of medians. For similar
!  reasons, we also have at least 2N/7 values not lower than XMED7. At the
!  same time, we find in each subset the index of the last value < XMED7,
!  and that of the first > XMED7. These indices will be used to restrict the
!  search for the median as the Kth element in the subset (> or <) where
!  we know it to be.
!
         IDON1 = 1
         NLEQ = 0
         NEQU = 0
         Do IDON = 1, NTRI, 7
            IMED = IDON+3
            If (XWRKT (IMED) > XMED7) Then
                  IMED = IMED - 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Else If (XWRKT (IMED) < XMED7) Then
                  IMED = IMED + 2
                  If (XWRKT (IMED) > XMED7) Then
                     IMED = IMED - 1
                  Else If (XWRKT (IMED) < XMED7) Then
                     IMED = IMED + 1
                  Endif
            Endif
            If (XWRKT (IMED) > XMED7) Then
               NLEQ = NLEQ + IMED - IDON
               IENDT (IDON1) = IMED - 1
               ISTRT (IDON1) = IMED
            Else If (XWRKT (IMED) < XMED7) Then
               NLEQ = NLEQ + IMED - IDON + 1
               IENDT (IDON1) = IMED
               ISTRT (IDON1) = IMED + 1
            Else                    !       If (XWRKT (IMED) == XMED7)
               NLEQ = NLEQ + IMED - IDON + 1
               NEQU = NEQU + 1
               IENDT (IDON1) = IMED - 1
               Do IMED1 = IMED - 1, IDON, -1
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     IENDT (IDON1) = IMED1 - 1
                  Else
                     Exit
                  End If
               End Do
               ISTRT (IDON1) = IMED + 1
               Do IMED1 = IMED + 1, IDON + 6
                  If (XWRKT (IMED1) == XMED7) Then
                     NEQU = NEQU + 1
                     NLEQ = NLEQ + 1
                     ISTRT (IDON1) = IMED1 + 1
                  Else
                     Exit
                  End If
               End Do
            Endif
            IDON1 = IDON1 + 1
         End Do
!
!  Carry out a partial insertion sort to find the Kth smallest of the
!  large values, or the Kth largest of the small values, according to
!  what is needed.
!
        If (NLEQ - NEQU + 1 <= NMED) Then
            If (NLEQ < NMED) Then   !      Not enough low values
                XWRK1 = XHUGE
                NORD = NMED - NLEQ
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                IDCR = 0
               Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) < XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                           If (ICRS2 < NORD) Then
                              XWRKT (ICRS1) = XWRKT (ICRS)
                              XWRK1 = XWRKT(ICRS1)
                           Endif
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = ISTRT (IDON1), IDON + 6
                         If (XWRKT(ICRS) >= XWRK1) Exit
                         XWRK = XWRKT (ICRS)
                         Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK >= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                         End Do
                         XWRKT (IDCR+1) = XWRK
                         XWRK1 = XWRKT(ICRS1)
                      End Do
                   End If
                End Do
                res_med = XWRK1
                Return
            Else
                res_med = XMED7
                Return
            End If
         Else                       !      If (NLEQ > NMED)
!                                          Not enough high values
                XWRK1 = -XHUGE
                NORD = NLEQ - NEQU - NMED + 1
                IDON1 = 0
                ICRS1 = 1
                ICRS2 = 0
                Do IDON = 1, NTRI, 7
                   IDON1 = IDON1 + 1
                   If (ICRS2 < NORD) Then
!
                      Do ICRS = IDON, IENDT (IDON1)
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            If (ICRS2 < NORD) Then
                               XWRKT (ICRS1) = XWRKT (ICRS)
                               XWRK1 = XWRKT (ICRS1)
                            End If
                         End If
                         ICRS1 = MIN (NORD, ICRS1 + 1)
                         ICRS2 = MIN (NORD, ICRS2 + 1)
                      End Do
                   Else
                      Do ICRS = IENDT (IDON1), IDON, -1
                         If (XWRKT(ICRS) > XWRK1) Then
                            XWRK = XWRKT (ICRS)
                            IDCR = ICRS1 - 1
                            Do IDCR = ICRS1 - 1, 1, - 1
                               If (XWRK <= XWRKT(IDCR)) Exit
                               XWRKT (IDCR+1) = XWRKT (IDCR)
                            End Do
                            XWRKT (IDCR+1) = XWRK
                            XWRK1 = XWRKT(ICRS1)
                         Else
                            Exit
                         End If
                      End Do
                   Endif
                End Do
!
                res_med = XWRK1
                Return
         End If
!
End Function I_valmed
end module m_valmed
Module m_valnth
Integer, Parameter :: kdp = selected_real_kind(15)
public :: valnth
private :: kdp
private :: R_valnth, I_valnth, D_valnth
interface valnth
  module procedure d_valnth, r_valnth, i_valnth
end interface valnth
contains

Function D_valnth (XDONT, NORD) Result (valnth)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Real (Kind=kdp), Dimension (:), Intent (In) :: XDONT
      Real (Kind=kdp) :: valnth
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real (Kind=kdp), Dimension (SIZE(XDONT)) :: XLOWT, XHIGT
      Real (Kind=kdp) :: XPIV, XPIV0, XWRK, XWRK1, XWRK2, XWRK3, XMIN, XMAX
!
      Integer :: NDON, JHIG, JLOW, IHIG
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = MAX (MIN (NORD, NDON), 1)
!
!    First loop is used to fill-in XLOWT, XHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) VALNTH = XDONT (1)
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         XLOWT (1) = XDONT(2)
         XHIGT (1) = XDONT(1)
      Else
         XLOWT (1) = XDONT(1)
         XHIGT (1) = XDONT(2)
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) VALNTH = XLOWT (1)
         If (INTH == 2) VALNTH = XHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XHIGT(1)) Then
         XHIGT (2) = XHIGT (1)
         If (XDONT(3) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(3)
         Else
            XHIGT (1) = XDONT(3)
         End If
      Else
         XHIGT (2) = XDONT(3)
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!
      If (XDONT(NDON) < XHIGT(1)) Then
         XHIGT (3) = XHIGT (2)
         XHIGT (2) = XHIGT (1)
         If (XDONT(NDON) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(NDON)
         Else
            XHIGT (1) = XDONT(NDON)
         End If
      Else
         XHIGT (3) = XDONT(NDON)
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * (XHIGT(3)-XLOWT(1))
      If (XPIV >= XHIGT(1)) Then
         XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * &
                           (XHIGT(2)-XLOWT(1))
         If (XPIV >= XHIGT(1)) &
             XPIV = XLOWT(1) + REAL (2*INTH) / REAL (NDON+INTH) * &
                               (XHIGT(1)-XLOWT(1))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the XHIGT array as soon as we have more
!  than enough values in XLOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XHIGT(1)
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XHIGT(ICRS) < XMIN) Then
                      XMIN = XHIGT(ICRS)
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                XLOWT (JLOW) = XHIGT (IHIG)
                XHIGT (IHIG) = XHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                XMAX = XLOWT (JLOW)
                JLOW = JLOW - 1
                Do ICRS = 1, JLOW
                   If (XLOWT(ICRS) > XMAX) Then
                      XWRK = XMAX
                      XMAX = XLOWT(ICRS)
                      XLOWT (ICRS) = XWRK
                   End If
                End Do
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XHIGT(1) <= XHIGT(2)) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
               Else
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (3)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (3) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  XLOWT (ICRS) = XHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (IFIN)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (IFIN) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
!
               XWRK1 = XHIGT (1)
               JLOW = JLOW + 1
               XLOWT (JLOW) = XWRK1
               XPIV = XWRK1 + 0.5 * (XHIGT(IFIN)-XWRK1)
!
!  One takes values <= pivot to XLOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XHIGT(1)
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XHIGT(ICRS) < XMIN) Then
                  XMIN = XHIGT(ICRS)
                  IHIG = ICRS
               End If
            End Do
!
            VALNTH = XHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            XHIGT (1) = XLOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               XWRK = XLOWT (ICRS)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XHIGT(IDCR)) Then
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               XHIGT (IDCR+1) = XWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XHIGT(INTH)
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XLOWT (ICRS) < XWRK1) Then
                  XWRK = XLOWT (ICRS)
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XHIGT(IDCR)) Exit
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  End Do
                  XHIGT (IDCR+1) = XLOWT (ICRS)
                  XWRK1 = XHIGT(INTH)
               End If
               ILOW = ILOW + 1
            End Do
!
            VALNTH = XHIGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XLOWT(IMIL) < XLOWT(1)) Then
               XWRK = XLOWT (1)
               XLOWT (1) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
            End If
            If (XLOWT(IMIL) > XLOWT(IFIN)) Then
               XWRK = XLOWT (IFIN)
               XLOWT (IFIN) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
               If (XLOWT(IMIL) < XLOWT(1)) Then
                  XWRK = XLOWT (1)
                  XLOWT (1) = XLOWT (IMIL)
                  XLOWT (IMIL) = XWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XLOWT(1) + REAL(INTH)/REAL(JLOW+INTH) * &
                              (XLOWT(IFIN)-XLOWT(1))

!
!  One takes values > XPIV to XHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XLOWT(IFIN) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XLOWT(ICRS) <= XPIV) Then
                        JLOW = JLOW + 1
                        XLOWT (JLOW) = XLOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XLOWT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!
      VALNTH = MAXVAL (XLOWT (1:INTH))
      Return
!
!
End Function D_valnth

Function R_valnth (XDONT, NORD) Result (valnth)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! _________________________________________________________
      Real, Dimension (:), Intent (In) :: XDONT
      Real :: valnth
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Real, Dimension (SIZE(XDONT)) :: XLOWT, XHIGT
      Real :: XPIV, XPIV0, XWRK, XWRK1, XWRK2, XWRK3, XMIN, XMAX
!
      Integer :: NDON, JHIG, JLOW, IHIG
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = MAX (MIN (NORD, NDON), 1)
!
!    First loop is used to fill-in XLOWT, XHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) VALNTH = XDONT (1)
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         XLOWT (1) = XDONT(2)
         XHIGT (1) = XDONT(1)
      Else
         XLOWT (1) = XDONT(1)
         XHIGT (1) = XDONT(2)
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) VALNTH = XLOWT (1)
         If (INTH == 2) VALNTH = XHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XHIGT(1)) Then
         XHIGT (2) = XHIGT (1)
         If (XDONT(3) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(3)
         Else
            XHIGT (1) = XDONT(3)
         End If
      Else
         XHIGT (2) = XDONT(3)
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!
      If (XDONT(NDON) < XHIGT(1)) Then
         XHIGT (3) = XHIGT (2)
         XHIGT (2) = XHIGT (1)
         If (XDONT(NDON) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(NDON)
         Else
            XHIGT (1) = XDONT(NDON)
         End If
      Else
         XHIGT (3) = XDONT(NDON)
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * (XHIGT(3)-XLOWT(1))
      If (XPIV >= XHIGT(1)) Then
         XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * &
                           (XHIGT(2)-XLOWT(1))
         If (XPIV >= XHIGT(1)) &
             XPIV = XLOWT(1) + REAL (2*INTH) / REAL (NDON+INTH) * &
                               (XHIGT(1)-XLOWT(1))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the XHIGT array as soon as we have more
!  than enough values in XLOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XHIGT(1)
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XHIGT(ICRS) < XMIN) Then
                      XMIN = XHIGT(ICRS)
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                XLOWT (JLOW) = XHIGT (IHIG)
                XHIGT (IHIG) = XHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                XMAX = XLOWT (JLOW)
                JLOW = JLOW - 1
                Do ICRS = 1, JLOW
                   If (XLOWT(ICRS) > XMAX) Then
                      XWRK = XMAX
                      XMAX = XLOWT(ICRS)
                      XLOWT (ICRS) = XWRK
                   End If
                End Do
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XHIGT(1) <= XHIGT(2)) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
               Else
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (3)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (3) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  XLOWT (ICRS) = XHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (IFIN)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (IFIN) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
!
               XWRK1 = XHIGT (1)
               JLOW = JLOW + 1
               XLOWT (JLOW) = XWRK1
               XPIV = XWRK1 + 0.5 * (XHIGT(IFIN)-XWRK1)
!
!  One takes values <= pivot to XLOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XHIGT(1)
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XHIGT(ICRS) < XMIN) Then
                  XMIN = XHIGT(ICRS)
                  IHIG = ICRS
               End If
            End Do
!
            VALNTH = XHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            XHIGT (1) = XLOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               XWRK = XLOWT (ICRS)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XHIGT(IDCR)) Then
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               XHIGT (IDCR+1) = XWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XHIGT(INTH)
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XLOWT (ICRS) < XWRK1) Then
                  XWRK = XLOWT (ICRS)
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XHIGT(IDCR)) Exit
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  End Do
                  XHIGT (IDCR+1) = XLOWT (ICRS)
                  XWRK1 = XHIGT(INTH)
               End If
               ILOW = ILOW + 1
            End Do
!
            VALNTH = XHIGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XLOWT(IMIL) < XLOWT(1)) Then
               XWRK = XLOWT (1)
               XLOWT (1) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
            End If
            If (XLOWT(IMIL) > XLOWT(IFIN)) Then
               XWRK = XLOWT (IFIN)
               XLOWT (IFIN) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
               If (XLOWT(IMIL) < XLOWT(1)) Then
                  XWRK = XLOWT (1)
                  XLOWT (1) = XLOWT (IMIL)
                  XLOWT (IMIL) = XWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XLOWT(1) + REAL(INTH)/REAL(JLOW+INTH) * &
                              (XLOWT(IFIN)-XLOWT(1))

!
!  One takes values > XPIV to XHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XLOWT(IFIN) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XLOWT(ICRS) <= XPIV) Then
                        JLOW = JLOW + 1
                        XLOWT (JLOW) = XLOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XLOWT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!
      VALNTH = MAXVAL (XLOWT (1:INTH))
      Return
!
!
End Function R_valnth
Function I_valnth (XDONT, NORD) Result (valnth)
!  Return NORDth value of XDONT, i.e fractile of order NORD/SIZE(XDONT).
! __________________________________________________________
!  This routine uses a pivoting strategy such as the one of
!  finding the median based on the quicksort algorithm, but
!  we skew the pivot choice to try to bring it to NORD as
!  fast as possible. It uses 2 temporary arrays, where it
!  stores the indices of the values smaller than the pivot
!  (ILOWT), and the indices of values larger than the pivot
!  that we might still need later on (IHIGT). It iterates
!  until it can bring the number of values in ILOWT to
!  exactly NORD, and then finds the maximum of this set.
!  Michel Olagnon - Aug. 2000
! __________________________________________________________
! __________________________________________________________
      Integer, Dimension (:), Intent (In) :: XDONT
      Integer :: valnth
      Integer, Intent (In) :: NORD
! __________________________________________________________
      Integer, Dimension (SIZE(XDONT)) :: XLOWT, XHIGT
      Integer :: XPIV, XPIV0, XWRK, XWRK1, XWRK2, XWRK3, XMIN, XMAX
!
      Integer :: NDON, JHIG, JLOW, IHIG
      Integer :: IMIL, IFIN, ICRS, IDCR, ILOW
      Integer :: JLM2, JLM1, JHM2, JHM1, INTH
!
      NDON = SIZE (XDONT)
      INTH = MAX (MIN (NORD, NDON), 1)
!
!    First loop is used to fill-in XLOWT, XHIGT at the same time
!
      If (NDON < 2) Then
         If (INTH == 1) VALNTH = XDONT (1)
         Return
      End If
!
!  One chooses a pivot, best estimate possible to put fractile near
!  mid-point of the set of low values.
!
      If (XDONT(2) < XDONT(1)) Then
         XLOWT (1) = XDONT(2)
         XHIGT (1) = XDONT(1)
      Else
         XLOWT (1) = XDONT(1)
         XHIGT (1) = XDONT(2)
      End If
!
      If (NDON < 3) Then
         If (INTH == 1) VALNTH = XLOWT (1)
         If (INTH == 2) VALNTH = XHIGT (1)
         Return
      End If
!
      If (XDONT(3) < XHIGT(1)) Then
         XHIGT (2) = XHIGT (1)
         If (XDONT(3) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(3)
         Else
            XHIGT (1) = XDONT(3)
         End If
      Else
         XHIGT (2) = XDONT(3)
      End If
!
      If (NDON < 4) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!
      If (XDONT(NDON) < XHIGT(1)) Then
         XHIGT (3) = XHIGT (2)
         XHIGT (2) = XHIGT (1)
         If (XDONT(NDON) < XLOWT(1)) Then
            XHIGT (1) = XLOWT (1)
            XLOWT (1) = XDONT(NDON)
         Else
            XHIGT (1) = XDONT(NDON)
         End If
      Else
         XHIGT (3) = XDONT(NDON)
      End If
!
      If (NDON < 5) Then
         If (INTH == 1) Then
             VALNTH = XLOWT (1)
         Else
             VALNTH = XHIGT (INTH - 1)
         End If
         Return
      End If
!

      JLOW = 1
      JHIG = 3
      XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * (XHIGT(3)-XLOWT(1))
      If (XPIV >= XHIGT(1)) Then
         XPIV = XLOWT(1) + REAL(2*INTH)/REAL(NDON+INTH) * &
                           (XHIGT(2)-XLOWT(1))
         If (XPIV >= XHIGT(1)) &
             XPIV = XLOWT(1) + REAL (2*INTH) / REAL (NDON+INTH) * &
                               (XHIGT(1)-XLOWT(1))
      End If
      XPIV0 = XPIV
!
!  One puts values > pivot in the end and those <= pivot
!  at the beginning. This is split in 2 cases, so that
!  we can skip the loop test a number of times.
!  As we are also filling in the work arrays at the same time
!  we stop filling in the XHIGT array as soon as we have more
!  than enough values in XLOWT.
!
!
      If (XDONT(NDON) > XPIV) Then
         ICRS = 3
         Do
            ICRS = ICRS + 1
            If (XDONT(ICRS) > XPIV) Then
               If (ICRS >= NDON) Exit
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
!  One restricts further processing because it is no use
!  to store more high values
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               Else If (ICRS >= NDON) Then
                  Exit
               End If
            End Do
         End If
!
!
      Else
!
!  Same as above, but this is not as easy to optimize, so the
!  DO-loop is kept
!
         Do ICRS = 4, NDON - 1
            If (XDONT(ICRS) > XPIV) Then
               JHIG = JHIG + 1
               XHIGT (JHIG) = XDONT(ICRS)
            Else
               JLOW = JLOW + 1
               XLOWT (JLOW) = XDONT(ICRS)
               If (JLOW >= INTH) Exit
            End If
         End Do
!
         If (ICRS < NDON-1) Then
            Do
               ICRS = ICRS + 1
               If (XDONT(ICRS) <= XPIV) Then
                  If (ICRS >= NDON) Exit
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XDONT(ICRS)
               End If
            End Do
         End If
      End If
!
      JLM2 = 0
      JLM1 = 0
      JHM2 = 0
      JHM1 = 0
      Do
         If (JLM2 == JLOW .And. JHM2 == JHIG) Then
!
!   We are oscillating. Perturbate by bringing JLOW closer by one
!   to INTH
!
             If (INTH > JLOW) Then
                XMIN = XHIGT(1)
                IHIG = 1
                Do ICRS = 2, JHIG
                   If (XHIGT(ICRS) < XMIN) Then
                      XMIN = XHIGT(ICRS)
                      IHIG = ICRS
                   End If
                End Do
!
                JLOW = JLOW + 1
                XLOWT (JLOW) = XHIGT (IHIG)
                XHIGT (IHIG) = XHIGT (JHIG)
                JHIG = JHIG - 1
             Else

                XMAX = XLOWT (JLOW)
                JLOW = JLOW - 1
                Do ICRS = 1, JLOW
                   If (XLOWT(ICRS) > XMAX) Then
                      XWRK = XMAX
                      XMAX = XLOWT(ICRS)
                      XLOWT (ICRS) = XWRK
                   End If
                End Do
             End If
         End If
         JLM2 = JLM1
         JLM1 = JLOW
         JHM2 = JHM1
         JHM1 = JHIG
!
!   We try to bring the number of values in the low values set
!   closer to INTH.
!
         Select Case (INTH-JLOW)
         Case (2:)
!
!   Not enough values in low part, at least 2 are missing
!
            INTH = INTH - JLOW
            JLOW = 0
            Select Case (JHIG)
!!!!!           CASE DEFAULT
!!!!!              write (unit=*,fmt=*) "Assertion failed"
!!!!!              STOP
!
!   We make a special case when we have so few values in
!   the high values set that it is bad performance to choose a pivot
!   and apply the general algorithm.
!
            Case (2)
               If (XHIGT(1) <= XHIGT(2)) Then
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
               Else
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (2)
                  JLOW = JLOW + 1
                  XLOWT (JLOW) = XHIGT (1)
               End If
               Exit
!
            Case (3)
!
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (3)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (3) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
               JHIG = 0
               Do ICRS = JLOW + 1, INTH
                  JHIG = JHIG + 1
                  XLOWT (ICRS) = XHIGT (JHIG)
               End Do
               JLOW = INTH
               Exit
!
            Case (4:)
!
!
               XPIV0 = XPIV
               IFIN = JHIG
!
!  One chooses a pivot from the 2 first values and the last one.
!  This should ensure sufficient renewal between iterations to
!  avoid worst case behavior effects.
!
               XWRK1 = XHIGT (1)
               XWRK2 = XHIGT (2)
               XWRK3 = XHIGT (IFIN)
               If (XWRK2 < XWRK1) Then
                  XHIGT (1) = XWRK2
                  XHIGT (2) = XWRK1
                  XWRK2 = XWRK1
               End If
               If (XWRK2 > XWRK3) Then
                  XHIGT (IFIN) = XWRK2
                  XHIGT (2) = XWRK3
                  XWRK2 = XWRK3
                  If (XWRK2 < XHIGT(1)) Then
                     XHIGT (2) = XHIGT (1)
                     XHIGT (1) = XWRK2
                  End If
               End If
!
               XWRK1 = XHIGT (1)
               JLOW = JLOW + 1
               XLOWT (JLOW) = XWRK1
               XPIV = XWRK1 + 0.5 * (XHIGT(IFIN)-XWRK1)
!
!  One takes values <= pivot to XLOWT
!  Again, 2 parts, one where we take care of the remaining
!  high values because we might still need them, and the
!  other when we know that we will have more than enough
!  low values in the end.
!
               JHIG = 0
               Do ICRS = 2, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                     If (JLOW >= INTH) Exit
                  Else
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XHIGT (ICRS)
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XHIGT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XHIGT (ICRS)
                  End If
               End Do
            End Select
!
!
         Case (1)
!
!  Only 1 value is missing in low part
!
            XMIN = XHIGT(1)
            IHIG = 1
            Do ICRS = 2, JHIG
               If (XHIGT(ICRS) < XMIN) Then
                  XMIN = XHIGT(ICRS)
                  IHIG = ICRS
               End If
            End Do
!
            VALNTH = XHIGT (IHIG)
            Return
!
!
         Case (0)
!
!  Low part is exactly what we want
!
            Exit
!
!
         Case (-5:-1)
!
!  Only few values too many in low part
!
            XHIGT (1) = XLOWT (1)
            ILOW = 1 + INTH - JLOW
            Do ICRS = 2, INTH
               XWRK = XLOWT (ICRS)
               Do IDCR = ICRS - 1, MAX (1, ILOW), - 1
                  If (XWRK < XHIGT(IDCR)) Then
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  Else
                     Exit
                  End If
               End Do
               XHIGT (IDCR+1) = XWRK
               ILOW = ILOW + 1
            End Do
!
            XWRK1 = XHIGT(INTH)
            ILOW = 2*INTH - JLOW
            Do ICRS = INTH + 1, JLOW
               If (XLOWT (ICRS) < XWRK1) Then
                  XWRK = XLOWT (ICRS)
                  Do IDCR = INTH - 1, MAX (1, ILOW), - 1
                     If (XWRK >= XHIGT(IDCR)) Exit
                     XHIGT (IDCR+1) = XHIGT (IDCR)
                  End Do
                  XHIGT (IDCR+1) = XLOWT (ICRS)
                  XWRK1 = XHIGT(INTH)
               End If
               ILOW = ILOW + 1
            End Do
!
            VALNTH = XHIGT(INTH)
            Return
!
!
         Case (:-6)
!
! last case: too many values in low part
!

            IMIL = (JLOW+1) / 2
            IFIN = JLOW
!
!  One chooses a pivot from 1st, last, and middle values
!
            If (XLOWT(IMIL) < XLOWT(1)) Then
               XWRK = XLOWT (1)
               XLOWT (1) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
            End If
            If (XLOWT(IMIL) > XLOWT(IFIN)) Then
               XWRK = XLOWT (IFIN)
               XLOWT (IFIN) = XLOWT (IMIL)
               XLOWT (IMIL) = XWRK
               If (XLOWT(IMIL) < XLOWT(1)) Then
                  XWRK = XLOWT (1)
                  XLOWT (1) = XLOWT (IMIL)
                  XLOWT (IMIL) = XWRK
               End If
            End If
            If (IFIN <= 3) Exit
!
            XPIV = XLOWT(1) + REAL(INTH)/REAL(JLOW+INTH) * &
                              (XLOWT(IFIN)-XLOWT(1))

!
!  One takes values > XPIV to XHIGT
!
            JHIG = 0
            JLOW = 0
!
            If (XLOWT(IFIN) > XPIV) Then
               ICRS = 0
               Do
                  ICRS = ICRS + 1
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                     If (ICRS >= IFIN) Exit
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               If (ICRS < IFIN) Then
                  Do
                     ICRS = ICRS + 1
                     If (XLOWT(ICRS) <= XPIV) Then
                        JLOW = JLOW + 1
                        XLOWT (JLOW) = XLOWT (ICRS)
                     Else
                        If (ICRS >= IFIN) Exit
                     End If
                  End Do
               End If
            Else
               Do ICRS = 1, IFIN
                  If (XLOWT(ICRS) > XPIV) Then
                     JHIG = JHIG + 1
                     XHIGT (JHIG) = XLOWT (ICRS)
                  Else
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                     If (JLOW >= INTH) Exit
                  End If
               End Do
!
               Do ICRS = ICRS + 1, IFIN
                  If (XLOWT(ICRS) <= XPIV) Then
                     JLOW = JLOW + 1
                     XLOWT (JLOW) = XLOWT (ICRS)
                  End If
               End Do
            End If
!
         End Select
!
      End Do
!
!  Now, we only need to find maximum of the 1:INTH set
!
      VALNTH = MAXVAL (XLOWT (1:INTH))
      Return
!
!
End Function I_valnth
end module m_valnth

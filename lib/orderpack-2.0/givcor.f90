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

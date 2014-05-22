#! /usr/bin/perl

use Scalar::Util qw(looks_like_number);

$MAX_VM_NUM = 128;
$MAX_RAM_SIZE = 4096;

# Name : log_msg
# Purpose : print log messages
sub log_msg
{
  # Get and print the input string
  print $_[0];
}

# Name : usr_config
# Purpose : prompt the user for configuration
sub usr_config
{
   log_msg($_[0]);
}

# Name : do_sanity_check
# Purpose : check for validity of parameters
sub do_sanity_check
{
  log_msg( "\nperforming sanity check\n" );
  if( -e $_[0] ) 
  {
    log_msg( "$_[0] exists\n" );
  }
  else 
  {
    log_msg( "$_[0] does not exist. Exitting !!!\n" );
    exit;
  }

  if( -e $_[1] ) 
  {
    log_msg( "$_[1] exists\n" );
  }
  else 
  {
    log_msg( "$_[1] does not exist. Exitting !!!\n" );
    exit;
  }

  if(looks_like_number($_[2]) && $_[2] > 0 && $_[2] <= $MAX_RAM_SIZE)
  {
    log_msg( "$_[2] is a valid RAM size\n" );
  }
  else 
  {
    log_msg( "$_[2] is not a valid RAM size. Exitting !!!\n" );
    exit;
  }

  if(looks_like_number($_[3]) && $_[3] > 0 && $_[3] <= $MAX_VM_NUM)
  {
    log_msg( "$_[3] is a valid virtual machine number\n" );
  }
  else 
  {
    log_msg( "$_[3] is not a valid virtual machine number. Exitting !!!\n" );
    exit;
  }
  log_msg( "sanity check passed\n\n" );
}

# Name : get_ips
# Purpose : get a list of ips
sub get_ips
{
  # generate a list of private ip addresses
  log_msg( "Generate $_[0] ip addresses\n");
  $ip_prefix = "192.168.0.";

  for($idx = 0; $idx < $_[0]; $idx++)
  {
    push(@ip_array, $ip_prefix.$idx);
  }

  return @ip_array;
}

# Name : get_macs
# Purpose : get a list of ips
sub get_macs
{
  # generate a list of private ip addresses
  log_msg( "Generate $_[0] MAC addresses\n");
  $mac_prefix = "52:54:00:12:34:";

  for($idx = 0; $idx < $_[0]; $idx++)
  {
    push(@mac_array, $mac_prefix.$idx);
  }

  return @mac_array;
}

# Name : construct_vms
# Purpose : construct virtual machine launch strings
sub construct_vms
{
  # generate the commands to launch the virtual machines
  log_msg( "Generate $_[3] virtual machine commands\n");
  for($idx = 0; $idx < $_[3]; $idx ++) 
  {
    push(@vm_cmd, $_[0]." ".$_[1]." -m ".$_[2]." -net user  -net nic,macaddr=$_[4][$idx],model=virtio &");
  }
  return @vm_cmd;
} 
  

# Name: main
# Purpose : configure user options
sub main
{
   log_msg("starting configuring cluster\n"); 
  
   # get qemu exectuable 
   usr_config("path to QEMU exectuable : ");
   $qemu_exec = <>;

   # get OS image
   usr_config("path to OS image : ");
   $qemu_os = <>;
   
   # get RAM size
   usr_config("virtual machine's ram size : ");
   $qemu_ram = <>;

   # number of virtual machines 
   usr_config("number of virtual machines : ");
   $qemu_vmn = <>;
  
   chomp($qemu_exec);
   chomp($qemu_os);
   chomp($qemu_ram);
   chomp($qemu_vmn);

   if($qemu_exec eq "")
   {
     $qemu_exec = "/home/xtong/research/qemu-kvm-0.14.0/x86_64-softmmu/qemu-system-x86_64";
   }
   if($qemu_os eq "")
   {
     $qemu_os = "/home/xtong/research/qemu-kvm-0.14.0/x86_64-softmmu/ubuntu.img";
   }

   do_sanity_check($qemu_exec, $qemu_os, $qemu_ram, $qemu_vmn);

   @ip_list = get_ips($qemu_vmn);
   
   @mac_list = get_macs($qemu_vmn);

   @cmd_list = construct_vms($qemu_exec, $qemu_os, $qemu_ram, $qemu_vmn, \@mac_list);
   foreach(@cmd_list) 
   {
     log_msg( "Running $_\n\n" );
     system($_);
     sleep 5;
   }

}


main();

"""OCT V100 profile with post-boot script.
"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.


# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# We use the URN library below.
import geni.urn as urn
# Emulab extension
import geni.rspec.emulab

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Pick your image.
imageList = [('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD', 'UBUNTU 20.04'),
             ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD', 'UBUNTU 22.04')] 

pc.defineParameter("nodes","List of nodes",
                   portal.ParameterType.STRING,"",
                   longDescription="Comma-separated list of nodes (e.g., pc176,pc177). Please check the list of available nodes within the Mass cluster at https://www.cloudlab.us/cluster-status.php before you specify the nodes.")
                 
pc.defineParameter("osImage", "Select Image",
                   portal.ParameterType.IMAGE,
                   imageList[0], imageList,
                   longDescription="Supported operating systems are Ubuntu and CentOS.")    

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()        

# Check parameter validity.
  
pc.verifyParameters()

lan = request.LAN()

nodeList = params.nodes.split(',')

# Process nodes, adding to FPGA network
i = 0
for nodeName in nodeList:
    host = request.RawPC(nodeName)
    # UMass cluster
    bs = host.Blockstore("bs", "/mydata")
    bs.size = "80GB"
    host.component_manager_id = "urn:publicid:IDN+cloudlab.umass.edu+authority+cm"
    host.component_id = nodeName
    host.disk_image = params.osImage

    host.addService(pg.Execute(shell="bash", command="sudo /local/repository/post-boot.sh  >> /local/logs/output_log.txt")) 
    host_iface1 = host.addInterface()
    host_iface1.component_id = "eth2"
    host_iface1.addAddress(pg.IPv4Address("192.168.40." + str(i+30), "255.255.255.0")) 
  
    i+=1

pc.printRequestRSpec(request)

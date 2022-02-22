using Microsoft.Xrm.Sdk;

namespace SampleAppSolution4.Plugins
{
    public class SamplePluginCreate : PluginBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="PostInspectionResponseCreate"/> class.
        /// </summary>
        /// <param name="unsecure">Contains public (unsecure) configuration information.</param>
        /// <param name="secure">Contains non-public (secure) configuration information. 
        /// When using Microsoft Dynamics CRM for Outlook with Offline Access, 
        /// the secure string is not passed to a plug-in that executes while the client is offline.</param>
        public SamplePluginCreate(string unsecure, string secure)
            : base(typeof(SamplePluginCreate))
        {
        }

        /// <summary>
        /// Executes the plug-in.
        /// </summary>
        /// <param name="localContext">The <see cref="LocalPluginContext"/> which contains the
        /// <see cref="IPluginExecutionContext"/>,
        /// <see cref="IOrganizationService"/>
        /// and <see cref="ITracingService"/>
        /// </param>
        /// <remarks>
        /// For improved performance, Microsoft Dynamics CRM caches plug-in instances.
        /// The plug-in's Execute method should be written to be stateless as the constructor
        /// is not called for every invocation of the plug-in. Also, multiple system threads
        /// could execute the plug-in at the same time. All per invocation state information
        /// is stored in the context. This means that you should not use global variables in plug-ins.
        /// </remarks>
        protected override void ExecuteCrmPlugin(LocalPluginContext localContext)
        {
            if (localContext == null)
            {
                throw new InvalidPluginExecutionException("localContext");
            }

            // Do something here
        }
    }
}
